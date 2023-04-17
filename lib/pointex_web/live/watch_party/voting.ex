defmodule PointexWeb.WatchParty.Voting do
  use PointexWeb, :live_view
  alias Pointex.Model.PossiblePoints
  alias Pointex.Model.ReadModels.WatchPartyVoting
  alias Pointex.Model.Commands
  alias PointexWeb.Endpoint
  alias PointexWeb.WatchParty.Nav
  alias PointexWeb.WatchParty.SongComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="relative">
      <Nav.nav wp_id={@wp_id} mobile={false} active={:voting} />
      <div class="flex flex-col sm:flex-row gap-4 my-2">
        <.top_10 songs={@songs} />
        <flex class="flex flex-col gap-4 w-full overflow-x-hidden">
          <.unvoted_section
            label="👍 Shortlisted"
            songs={unvoted_subset(@songs, :shortlisted)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-r from-green-100"
          />
          <.unvoted_section
            label="🫤 Undecided"
            songs={unvoted_subset(@songs, :meh)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-r from-gray-200"
          />
          <.unvoted_section
            label="💩 Noped"
            songs={unvoted_subset(@songs, :noped)}
            selected_id={@selected_id}
            header_class="bg-gradient-to-r from-red-100"
          />
        </flex>
      </div>
      <Nav.nav wp_id={@wp_id} mobile={true} active={:voting} />
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    if connected?(socket), do: Endpoint.subscribe("watch_party_voting:#{wp_id}")

    {:noreply, assign(socket, load_data(wp_id, user(socket).id))}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_selected", params, socket) do
    current_selected_id = socket.assigns.selected_id
    selected_id = if params["id"] == current_selected_id, do: nil, else: params["id"]

    {:noreply, assign(socket, selected_id: selected_id)}
  end

  def handle_event("give_points", params, socket) do
    {song_id, points} =
      case params do
        %{"id" => song_id, "points" => points} -> {song_id, points}
        %{"id" => song_id} -> {song_id, nil}
      end

    :ok =
      Commands.GivePointsToSong.dispatch_new(%{
        watch_party_id: socket.assigns.wp_id,
        participant_id: user(socket).id,
        song_id: song_id,
        points: points
      })

    {:noreply, assign(socket, selected_id: nil)}
  end

  @impl Phoenix.LiveView
  def handle_info(%{event: "updated"}, socket) do
    {:noreply, assign(socket, load_data(socket.assigns.wp_id, user(socket).id))}
  end

  defp load_data(wp_id, user_id) do
    read_model = WatchPartyVoting.get(wp_id, user_id)

    %{wp_id: wp_id, songs: read_model.songs, selected_id: nil}
  end

  defp unvoted_subset(songs, viewing_result) do
    Enum.filter(songs, &(&1.points < 1 && &1.viewing_result == viewing_result))
  end

  defp voted(songs, points) do
    Enum.find(songs, &(&1.points == points))
  end

  defp top_10(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label="🏅 My TOP 10" class="" />
      <div class="flex flex-col divide-y divide-gray-200 bg-white shadow-lg border border-gray-200">
        <.points_given
          :for={points <- PossiblePoints.desc()}
          points={points}
          song={voted(@songs, points)}
          song_above={voted(@songs, PossiblePoints.inc(points))}
          song_below={voted(@songs, PossiblePoints.dec(points))}
        />
      </div>
    </section>
    """
  end

  defp unvoted_section(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label={@label} class={@header_class} />
      <div class="flex flex-col divide-y divide-gray-200 my-2">
        <.song_with_no_points :for={song <- @songs} song={song} selected={song.id == @selected_id} />
      </div>
    </section>
    """
  end

  defp section_header(assigns) do
    ~H"""
    <h2 class={["uppercase text-sm text-gray-500 px-2 py-2", @class]}>
      <%= @label %>
    </h2>
    """
  end

  defp points_given(assigns) do
    %{song: song, song_below: song_below, points: points} = assigns

    assigns =
      assign(
        assigns,
        down_button_params: song &&
          if(song_below,
            do: %{"phx-value-id" => song_below.id, "phx-value-points" => points},
            else: %{"phx-value-id" => assigns.song.id, "phx-value-points" => PossiblePoints.dec(points)}
          )
      )

    ~H"""
    <div class="flex" >
      <.points_label points={@points} active={@song != nil} />
      <div :if={@song} class="grow flex gap-4 px-2 py-2 w-72 transition-all">
        <SongComponents.description song={@song} />

        <div class="flex gap-0 sm:gap-4 items-center">
          <.button
            phx-click="give_points"
            phx-value-id={@song.id}
            phx-value-points={PossiblePoints.inc(@points)}
            class={"#{if @points == 12, do: "invisible"} border border-transparent text-green-600 bg-transparent hover:bg-green-200 hover:border-green-500 hover:text-green-600 active:text-green-600"}
          >
            <.icon name="hero-arrow-small-up" class="w-8 h-8" />
          </.button>
          <.button
            phx-click="give_points"
            {@down_button_params}
            class="border border-transparent text-red-600 bg-transparent hover:bg-red-200 hover:border-red-700 hover:text-red-600 active:text-red-600"
          >
            <.icon name="hero-arrow-small-down" class="w-8 h-8" />
          </.button>
        </div>
      </div>
      <div :if={!@song} class="text-gray-300 px-2 py-2 w-72 transition-all">No song here (yet)</div>
    </div>
    """
  end

  defp points_label(assigns) do
    ~H"""
    <div class={[
      if(@active, do: "bg-sky-600 text-sky-100", else: "bg-gray-400 text-gray-100 animate-pulse"),
      "font-bold text-2xl w-12 flex items-center justify-center transition-all"
    ]}>
      <%= @points %>
    </div>
    """
  end

  defp song_with_no_points(assigns) do
    ~H"""
    <div class={[if(@selected, do: "bg-white shadow", else: "")]} >
      <div
        phx-click="toggle_selected"
        phx-value-id={@song.id}
        class={["flex items-top justify-between gap-2 px-2 sm:px-4 py-3 hover:bg-sky-100"]}
      >
        <SongComponents.ro song={@song} />
        <SongComponents.description song={@song} />
      </div>
      <div
        :if={@selected}
        phx-mounted={JS.transition({"ease-out duration-200", "h-0 py-0", "h-24 py-4"}, time: 10)}
        class="flex overflow-x-auto bg-gradient-to-b from-gray-200 to-gray-100/50 shadow-inner text-2xl border-t border-gray-200 px-2 transition-all"
      >
        <.points_button :for={points <- PossiblePoints.desc()} points={points} song_id={@song.id} />
      </div>
    </div>
    """
  end

  defp points_button(assigns) do
    ~H"""
    <div
      class="px-2 bg-transparent cursor-pointer"
      phx-click="give_points"
      phx-value-id={@song_id}
      phx-value-points={@points}
    >
      <div class="flex justify-center rounded-full bg-sky-600 py-3 text-white/80">
        <span class="w-14 text-center"><%= @points %></span>
      </div>
    </div>
    """
  end
end
