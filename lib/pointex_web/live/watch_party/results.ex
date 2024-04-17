defmodule PointexWeb.WatchParty.Results do
  use PointexWeb, :live_view
  alias Pointex.Europoints
  alias Pointex.Europoints.WatchParty
  alias PointexWeb.WatchParty.SongComponents
  alias PointexWeb.Endpoint
  alias PointexWeb.WatchParty.Nav

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Nav.layout wp_id={@wp_id} active={:results}>
      <div :if={!@results_visible} class="flex w-full justify-center py-32">
        <div class="max-w-lg mb-32 flex flex-col items-center bg-red-100 rounded-lg shadow-xl border border-red-200 overflow-clip">
          <div class="h-[6px] w-full bg-red-300" />
          <div class="px-16 py-8 flex flex-col gap-4">
            <h2 class="font-bold text-red-800">🙈 Hey hey!</h2>
            <p>
              <span class="text-black/50">No peeking! </span>
              <.link navigate={~p"/wp/#{@wp_id}/voting"} class="underline text-sky-800 mx-1">
                Finish your own voting first!
              </.link>
              <span>😉</span>
            </p>
          </div>
        </div>
      </div>
      <div :if={@results_visible} class="flex flex-col sm:flex-row gap-4 my-2">
        <.still_voting :if={@still_voting_participants != []} participants={@still_voting_participants} />
        <.wp_totals songs={@wp_totals} />
      </div>
    </Nav.layout>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    data = load_data(wp_id, user(socket).id)
    if connected?(socket), do: Endpoint.subscribe("watch_party:#{wp_id}")

    {:noreply,
     socket
     |> assign(page_title: "Results")
     |> assign(data)}
  end

  @impl Phoenix.LiveView
  def handle_info(_, socket) do
    {:noreply, assign(socket, load_data(socket.assigns.wp_id, user(socket).id))}
  end

  defp load_data(wp_id, user_id) do
    watch_party = Europoints.get!(WatchParty, wp_id, action: :results)
    participant = Enum.find(watch_party.participants, &(&1.account_id == user_id))

    %{
      wp_id: wp_id,
      results_visible: participant.final_vote_submitted,
      wp_totals:
        watch_party.total_points_by_participants
        |> Enum.sort_by(& &1.points, :desc)
        |> Enum.with_index(1),
      still_voting_participants: Enum.reject(watch_party.participants, & &1.final_vote_submitted)
    }
  end

  defp still_voting(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label="⏳ Still Voting..." class="mb-4" />
      <div class="flex flex-wrap gap-4 place-items-start ml-4">
        <.participant :for={participant <- @participants} name={participant.account.name} />
      </div>
    </section>
    """
  end

  defp wp_totals(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label="🏅 Our Results" class="" />
      <div class="flex flex-col divide-y divide-gray-200 bg-white shadow-lg border border-gray-200">
        <.song :for={{%{song: song, points: points}, place} <- @songs} song={song} points={points} place={place} />
      </div>
    </section>
    """
  end

  defp song(assigns) do
    ~H"""
    <div class="flex">
      <div class="grow flex w-72 transition-all">
        <div :if={@place > 0} class={"w-8 font-bold text-black/25 text-2xl text-center " <> song_bg(@place)}>
          <%= @place %>
        </div>
        <SongComponents.description song={@song} class={song_bg(@place)} />
      </div>
      <.points_label points={@points} place={@place} />
    </div>
    """
  end

  defp section_header(assigns) do
    ~H"""
    <h2 class={["uppercase text-sm text-gray-500 px-2 py-2", @class]}>
      <%= @label %>
    </h2>
    """
  end

  defp points_label(assigns) do
    ~H"""
    <div class={[
      points_bg(@place, @points),
      "font-bold text-4xl w-24 flex items-center justify-center transition-all"
    ]}>
      <span class="">
        <%= if @place > 0 do %>
          <%= @points %>
        <% else %>
          ?
        <% end %>
      </span>
    </div>
    """
  end

  defp participant(assigns) do
    ~H"""
    <div class="flex items-center gap-1 rounded bg-red-50 text-red-900 shadow px-2 py-1 animate-bounce">
      <.icon name="hero-user-solid" class="text-red-800 h-3 w-3" />
      <span><%= @name %></span>
    </div>
    """
  end

  defp song_bg(1) do
    "p-2 bg-amber-100"
  end

  defp song_bg(2) do
    "p-2 bg-slate-100"
  end

  defp song_bg(3) do
    "p-2 bg-amber-600/10"
  end

  defp song_bg(_) do
    "p-2"
  end

  defp points_bg(1, _) do
    "bg-yellow-400 text-yellow-800"
  end

  defp points_bg(2, _) do
    "bg-slate-300 text-slate-600"
  end

  defp points_bg(3, _) do
    "bg-amber-600 text-amber-300"
  end

  defp points_bg(_, 0) do
    "bg-gray-100 text-gray-400"
  end

  defp points_bg(_place, _points) do
    "bg-sky-200 text-sky-500"
  end
end
