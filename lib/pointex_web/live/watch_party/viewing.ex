defmodule PointexWeb.WatchParty.Viewing do
  use PointexWeb, :live_view
  alias Pointex.Europoints.Participant
  alias Pointex.Europoints.WatchParty
  alias Pointex.Europoints.Song
  alias PointexWeb.Endpoint
  alias PointexWeb.WatchParty.NotFound
  alias PointexWeb.WatchParty.Nav
  alias PointexWeb.WatchParty.SongComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    %{show: show, songs: songs, participant: participant} = assigns
    assigns = assign(assigns, songs: Enum.map(songs, &SongComponents.prepare(&1, show.kind, participant)))

    ~H"""
    <Nav.layout wp_id={@wp_id} active={:viewing}>
      <div class="flex flex-col divide-y divide-gray-300 my-2">
        <.song_viewing :for={song <- @songs} song={song} />
      </div>
    </Nav.layout>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # TODO: protect from prying eyes
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    user_id = user(socket).id
    data = load_data(wp_id, user_id)

    if connected?(socket), do: Endpoint.subscribe("participant:#{data.participant.id}")

    {:noreply,
     socket
     |> assign(page_title: "Watching")
     |> assign(data)}
  end

  @impl Phoenix.LiveView
  def handle_event("shortlist", %{"id" => song_id}, socket) do
    %{participant: participant} = socket.assigns

    {:ok, participant} = Participant.toggle_shortlisted(participant, song_id)
    {:noreply, assign(socket, participant: participant)}
  end

  def handle_event("nope", %{"id" => song_id}, socket) do
    %{participant: participant} = socket.assigns

    {:ok, participant} = Participant.toggle_noped(participant, song_id)
    {:noreply, assign(socket, participant: participant)}
  end

  @impl Phoenix.LiveView
  def handle_info(%{payload: %{data: updated_participant}}, socket) do
    {:noreply, assign(socket, participant: updated_participant)}
  end

  defp load_data(wp_id, user_id) do
    with {:ok, %{show: show, participants: participants}} <- Ash.get(WatchParty, wp_id, load: [:show, :participants]),
         %{} = participant <- Enum.find(participants, &(&1.account_id == user_id)),
         {:ok, songs} <- Song.songs_in_show(show.year, show.kind) do
      %{wp_id: wp_id, show: show, participant: participant, songs: songs}
    else
      _ -> raise NotFound
    end
  end

  defp song_viewing(assigns) do
    ~H"""
    <SongComponents.song_container song={@song}>
      <div class="h-full flex items-top justify-between gap-2 px-2 sm:px-4 py-3 hover:bg-sky-100/50">
        <SongComponents.ro song={@song} />
        <SongComponents.description song={@song} />
        <div class="flex gap-1 sm:gap-4 items-center">
          <.shortlist_button id={@song.country} active={@song.shortlisted} />
          <.nope_button id={@song.country} active={@song.noped} />
        </div>
      </div>
    </SongComponents.song_container>
    """
  end

  defp shortlist_button(assigns) do
    ~H"""
    <button
      phx-click="shortlist"
      phx-value-id={@id}
      class={[
        "border border-transparent rounded-lg py-2 px-3 hover:border-green-500 hover:text-green-600 active:text-green-600 shadow-lg",
        if(@active,
          do: "bg-green-300 text-green-700 hover:bg-green-300",
          else: "text-green-500 bg-white/50 backdrop-blur-sm hover:bg-transparent"
        )
      ]}
    >
      <.icon name="hero-hand-thumb-up" class="w-8 h-8" />
    </button>
    """
  end

  defp nope_button(assigns) do
    ~H"""
    <button
      phx-click="nope"
      phx-value-id={@id}
      class={[
        "border border-transparent rounded-lg py-2 px-3 hover:border-red-700 hover:text-red-600 active:text-red-600 shadow-lg",
        if(@active,
          do: "bg-red-200 text-red-700 hover:bg-red-200",
          else: "text-red-600 bg-white/50 backdrop-blur-sm hover:bg-transparent"
        )
      ]}
    >
      <.icon name="hero-hand-thumb-down" class="w-8 h-8" />
    </button>
    """
  end
end
