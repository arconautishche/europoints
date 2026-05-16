defmodule PointexWeb.WatchParty.Voting do
  use PointexWeb, :live_view
  use Gettext, backend: PointexWeb.Gettext
  alias Pointex.Europoints.Song
  alias Pointex.Europoints.Participant
  alias Pointex.Europoints.WatchParty
  alias Pointex.Model.PossiblePoints
  alias PointexWeb.Endpoint
  alias PointexWeb.WatchParty.NotFound
  alias PointexWeb.WatchParty.Nav
  alias PointexWeb.WatchParty.SongComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    %{show: show, songs: songs, participant: participant} = assigns
    rendered_songs = Enum.map(songs, &SongComponents.prepare(&1, show.kind, participant))
    show_hint = Enum.all?(rendered_songs, &(&1.points == nil))
    votes_given = Enum.count(rendered_songs, &(&1.points != nil))

    assigns = assign(assigns, songs: rendered_songs, show_hint: show_hint, votes_given: votes_given)

    ~H"""
    <Nav.layout wp_id={@wp_id} active={:voting}>
      <div class="flex flex-col sm:flex-row gap-6 my-2">
        <div class="w-full flex flex-col items-center sticky top-0 z-10 -mb-4">
          <div :if={@votes_given > 0 and @votes_given < 10} class="w-full px-4 py-2 bg-white/60 text-gray-600 text-center">
            {ngettext("%{count} place left", "%{count} places left", 10 - @votes_given)}
          </div>
          <button
            :if={@participant.can_submit_final_vote}
            phx-click="submit_vote"
            class="flex w-fit gap-2 py-2 px-4 rounded-lg mt-2 bg-red-200 border border-red-800/20 shadow-lg text-red-800 uppercase"
          >
            <span class="animate-pulse">🚨</span>
            <span>This is my definitive top 10</span>
            <span class="animate-bounce">🚀</span>
          </button>
        </div>
        <.top_10 songs={@songs} readonly={@participant.final_vote_submitted} />
        <div :if={!@participant.final_vote_submitted} class="flex flex-col gap-4 w-full overflow-x-hidden">
          <.unvoted_section
            label="👍 Shortlisted"
            all_songs={@songs}
            songs={unvoted_subset(@songs, :shortlisted)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-b from-green-200 border-t border-green-600/50"
            used_points={@participant.used_points}
            unused_points={@participant.unused_points}
          />
          <.unvoted_section
            label="🫤 Undecided"
            all_songs={@songs}
            songs={unvoted_subset(@songs, :meh)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-b from-amber-200 border-t border-amber-600/50"
            used_points={@participant.used_points}
            unused_points={@participant.unused_points}
          />
          <.unvoted_section
            label="💩 Noped"
            all_songs={@songs}
            songs={unvoted_subset(@songs, :noped)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-b from-red-300 border-t border-red-600/50"
            used_points={@participant.used_points}
            unused_points={@participant.unused_points}
          />
        </div>
      </div>
    </Nav.layout>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    user_id = user(socket).id
    data = load_data(wp_id, user_id)

    if connected?(socket), do: Endpoint.subscribe("participant:#{data.participant.id}")

    {:noreply,
     socket
     |> assign(page_title: "Voting")
     |> assign(data)
     |> assign(selected_id: nil)}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_selected", params, socket) do
    current_selected_id = socket.assigns.selected_id
    selected_id = if params["id"] == current_selected_id, do: nil, else: params["id"]

    {:noreply, assign(socket, selected_id: selected_id)}
  end

  def handle_event("give_points", params, socket) do
    song_id = params["id"]
    points = params["points"]
    participant = socket.assigns.participant

    {:ok, participant} = Participant.give_points(participant, song_id, points)
    {:noreply, assign(socket, participant: participant)}
  end

  def handle_event("submit_vote", _params, socket) do
    {:ok, _} = Participant.finalize_top_10(socket.assigns.participant)
    {:noreply, push_navigate(socket, to: ~p"/wp/#{socket.assigns.wp_id}/results")}
  end

  def handle_event("reposition", params, socket) do
    song_id = params["id"]
    new_points = Enum.at(PossiblePoints.desc(), params["new"])
    participant = socket.assigns.participant

    current_points =
      Enum.find_value(participant.top_10_with_points, fn
        {points, ^song_id} -> points
        _ -> nil
      end)

    # TODO: Should this be implemented in Participant.give_points?
    participant =
      participant.top_10_with_points
      |> Enum.sort_by(&elem(&1, 0), :desc)
      |> Enum.reduce(participant, fn
        {_points, nil}, participant ->
          participant

        {_points, ^song_id}, participant ->
          Participant.give_points!(participant, song_id, nil)

        {points, song}, participant ->
          if points < current_points && points >= new_points do
            Participant.give_points!(participant, song, PossiblePoints.inc(points))
          else
            participant
          end
      end)

    participant = Participant.give_points!(participant, song_id, new_points)
    {:noreply, assign(socket, participant: participant)}
  end

  @impl Phoenix.LiveView
  def handle_info(%{payload: %{data: updated_participant}}, socket) do
    # TODO: replace participant with updated_participant if notification is coming from a different LV
    # {:noreply, assign(socket, participant: updated_participant)}
    {:noreply, socket}
  end

  defp load_data(wp_id, user_id) do
    with {:ok, %{show: show, participants: participants}} <- Ash.get(WatchParty, wp_id, load: [:show, :participants]),
         %{} = participant <- Enum.find(participants, &(&1.account_id == user_id)),
         {:ok, songs} <- Song.songs_in_show(show.year, show.kind) do
      %{
        wp_id: wp_id,
        show: show,
        participant: participant,
        songs: songs
      }
    else
      _ -> raise NotFound
    end
  end

  defp unvoted_subset(songs, :shortlisted) do
    Enum.filter(songs, &(&1.points == nil && &1.shortlisted))
  end

  defp unvoted_subset(songs, :noped) do
    Enum.filter(songs, &(&1.points == nil && &1.noped))
  end

  defp unvoted_subset(songs, _) do
    Enum.filter(songs, &(&1.points == nil && !&1.shortlisted && !&1.noped))
  end

  defp song_with_points(_songs, nil), do: nil

  defp song_with_points(songs, points) do
    Enum.find(songs, &(&1.points == points))
  end

  defp top_10(assigns) do
    first_free_spot = Enum.find(PossiblePoints.desc(), &(song_with_points(assigns.songs, &1) == nil))

    assigns =
      assigns
      |> assign(empty: Enum.all?(assigns.songs, &(&1.points == nil)))
      |> assign(first_free_spot: first_free_spot)

    ~H"""
    <section class="w-full">
      <.section_header label="🏅 My TOP 10" class="" />
      <div :if={@empty} class="sm:hidden flex gap-4 items-center mx-8 px-4 py-2 bg-blue-300 text-blue-900/75 shadow animate-bounce">
        <.icon name="hero-information-circle" class="bg-no-repeat" />
        <span>Scroll down to give points to your favorite songs</span>
      </div>
      <ul
        id="top-10-list"
        phx-hook="InitDragAndDrop"
        class={[
          "flex flex-col divide-y divide-gray-200 bg-white shadow-lg border border-gray-200 transition-all",
          if(@empty, do: "-mt-12 -mb-24")
        ]}
        style={
          if @empty,
            do: "transform: perspective(1cm) rotateX(-10deg) translate3d(0, 0, -100px) ",
            else: ""
        }
      >
        <.points_given
          :for={points <- PossiblePoints.desc()}
          points={points}
          readonly={@readonly}
          song={song_with_points(@songs, points)}
          song_above={song_with_points(@songs, PossiblePoints.inc(points))}
          song_below={song_with_points(@songs, PossiblePoints.dec(points))}
          first_free_spot={@first_free_spot}
        />
      </ul>
    </section>
    """
  end

  defp unvoted_section(assigns) do
    assigns = assign(assigns, used_points: Enum.map(assigns.used_points, &{&1, song_with_points(assigns.all_songs, &1)}))

    ~H"""
    <section :if={Enum.any?(@songs)} class="w-full">
      <.section_header label={@label} class={@header_class} />
      <div class="flex flex-col divide-y divide-gray-300">
        <.song_with_no_points
          :for={song <- @songs}
          song={song}
          selected={song.country == @selected_id}
          used_points={@used_points}
          unused_points={@unused_points}
        />
      </div>
    </section>
    """
  end

  defp section_header(assigns) do
    ~H"""
    <h2 class={["uppercase text-sm text-gray-500 px-2 py-2", @class]}>
      {@label}
    </h2>
    """
  end

  defp points_given(assigns) do
    %{song: song, song_below: song_below, points: points} = assigns

    assigns =
      assign(
        assigns,
        down_button_params:
          song &&
            if(song_below,
              do: %{"phx-value-id" => song_below.country, "phx-value-points" => points},
              else: %{
                "phx-value-id" => assigns.song.country,
                "phx-value-points" => PossiblePoints.dec(points)
              }
            )
      )

    ~H"""
    <li
      id={"points-#{@points}-#{@song && @song.country}"}
      data-id={@song && @song.country}
      class={["drag-ghost:bg-zinc-200 drag-ghost:py-4 drag-ghost:animate-pulse drag-item:scale-110", if(@readonly || !@song, do: "not-draggable")]}
    >
      <div class="flex drag-ghost:opacity-0">
        <.points_label points={@points} active={@song != nil} />
        <SongComponents.song_container :if={@song} song={@song}>
          <div class="h-full flex gap-4 px-2 py-2 transition-all">
            <SongComponents.description song={@song} />
            <div :if={!@readonly} class="flex gap-1 sm:gap-4 items-center">
              <button
                phx-click="give_points"
                phx-value-id={@song.country}
                phx-value-points={PossiblePoints.inc(@points)}
                class={"#{if @points == 12, do: "invisible"} border border-transparent rounded-lg text-green-600 bg-white/50 backdrop-blur-sm shadow-lg py-2 px-3 hover:bg-transparent sm:hover:bg-green-200 sm:hover:border-green-500 sm:hover:text-green-600 active:text-green-600"}
              >
                <.icon name="hero-arrow-small-up" class="w-8 h-8" />
              </button>
              <button
                phx-click="give_points"
                {@down_button_params}
                class="border border-transparent text-red-600 bg-white/50 backdrop-blur-sm shadow-lg rounded-lg py-2 px-3 hover:bg-transparent sm:hover:bg-red-200 sm:hover:border-red-700 sm:hover:text-red-600 active:text-red-600"
              >
                <.icon name="hero-arrow-small-down" class="w-8 h-8" />
              </button>
              <span class="text-gray-800/50">⋮⋮</span>
            </div>
          </div>
        </SongComponents.song_container>
        <div :if={!@song} class="text-gray-300 px-2 py-2 w-72 h-10 transition-all">
          <span :if={@first_free_spot == @points}>{hint_for_free_spot(@points)}</span>
        </div>
      </div>
    </li>
    """
  end

  defp points_label(assigns) do
    ~H"""
    <div class={[
      if(@active, do: "bg-sky-600 text-sky-100", else: "bg-gray-400 text-gray-100 animate-pulse text-xs"),
      "w-12 shrink-0 font-bold text-2xl flex items-center justify-center transition-all drag-item:animate-pulse"
    ]}>
      {@points}
    </div>
    """
  end

  defp song_with_no_points(assigns) do
    ~H"""
    <div class={[if(@selected, do: "bg-white shadow", else: "")]}>
      <div phx-click="toggle_selected" phx-value-id={@song.country} class={["flex items-top justify-between gap-2 hover:bg-sky-100"]}>
        <SongComponents.song_container song={@song}>
          <div class="flex px-2 sm:px-4 py-3">
            <SongComponents.ro song={@song} />
            <SongComponents.description song={@song} />
          </div>
        </SongComponents.song_container>
      </div>
      <div
        :if={@selected}
        phx-mounted={
          JS.transition(
            {"ease-out duration-200", "scale-y-0 py-0 opacity-50", "scale-y-100 py-4 opacity-100"},
            time: 10
          )
        }
        class="flex flex-col overflow-x-auto bg-gradient-to-b from-gray-200 to-gray-100/50 shadow-inner text-2xl border-t border-gray-200 px-2 origin-top transition-all scale-y-0 py-0 opacity-50"
      >
        <div class="flex">
          <.points_button :for={points <- @unused_points} points={points} song_id={@song.country} used={false} />
        </div>
        <span :if={@used_points != []} class="mt-4 mb-1 mx-2 text-gray-400 text-xs">
          Points already given, but you can give these to {@song.country} instead
        </span>
        <div class="flex">
          <.points_button
            :for={{points, song_with_points} <- @used_points}
            points={points}
            song_id={@song.country}
            song_with_points={song_with_points}
            used={true}
          />
        </div>
      </div>
    </div>
    """
  end

  defp points_button(assigns) do
    assigns = assign_new(assigns, :song_with_points, fn -> nil end) |> dbg()

    ~H"""
    <div class="px-2 bg-transparent cursor-pointer" phx-click="give_points" phx-value-id={@song_id} phx-value-points={@points}>
      <div class={"flex justify-center rounded-full #{if @used, do: "bg-sky-100 border border-sky-600/50 py-2 px-2 text-sky-800", else: "bg-sky-600 py-3 text-white/80"}"}>
        <span :if={not @used} class="text-center w-14">
          {@points}
        </span>
        <span :if={@used} class="text-center w-12 text-xl">
          {@points}
          {@song_with_points.flag}
        </span>
      </div>
    </div>
    """
  end

  defp hint_for_free_spot(12) do
    "👇 Who was the best?"
  end

  defp hint_for_free_spot(10) do
    "👇 Who gets the silver?"
  end

  defp hint_for_free_spot(1) do
    "👇 Last spot"
  end

  defp hint_for_free_spot(points) do
    "👇 Who gets #{points} points?"
  end
end
