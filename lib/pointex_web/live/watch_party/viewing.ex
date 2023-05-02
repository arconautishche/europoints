defmodule PointexWeb.WatchParty.Viewing do
  use PointexWeb, :live_view
  alias PointexWeb.Endpoint
  alias Pointex.Model.ReadModels.WatchPartyViewing
  alias Pointex.Model.Commands
  alias PointexWeb.WatchParty.Nav
  alias PointexWeb.WatchParty.SongComponents
  import Pointex.Model.ReadModels.Shows, only: [song_details: 1]

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Nav.layout wp_id={@wp_id} active={:viewing}>
      <div class="flex flex-col divide-y divide-gray-200 my-2">
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
    if connected?(socket), do: Endpoint.subscribe("watch_party_viewing:#{wp_id}:#{user_id}")

    {:noreply, socket
    |> assign(page_title: "Watching")
    |> assign(load_data(wp_id, user_id))}
  end

  @impl Phoenix.LiveView
  def handle_event("shortlist", %{"id" => song_id}, socket) do
    %{wp_id: wp_id} = socket.assigns

    :ok =
      Commands.ToggleSongShortlisted.dispatch_new(%{
        watch_party_id: wp_id,
        participant_id: user(socket).id,
        song_id: song_id
      })

    {:noreply, socket}
  end

  def handle_event("nope", %{"id" => song_id}, socket) do
    %{wp_id: wp_id} = socket.assigns

    :ok =
      Commands.ToggleSongNoped.dispatch_new(%{
        watch_party_id: wp_id,
        participant_id: user(socket).id,
        song_id: song_id
      })

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(%{event: "updated"}, socket) do
    {:noreply, assign(socket, load_data(socket.assigns.wp_id, user(socket).id))}
  end

  defp load_data(wp_id, user_id) do
    read_model = WatchPartyViewing.get(wp_id, user_id) |> IO.inspect() || %{songs: []}

    %{wp_id: wp_id, songs: read_model.songs}
  end

  defp song_viewing(assigns) do
    ~H"""
    <div class="relative">
      <div class={"absolute w-full h-full opacity-50 overflow-clip"}>
        <img src={"/images/#{song_details(@song.id)[:img]}"} class="object-cover w-full" />
      </div>
      <div class="absolute w-full h-full bg-gradient-to-b from-white/50 via-30% via-white/30 to-gray-100" />
      <div class="relative flex items-top justify-between gap-2 px-2 sm:px-4 py-3 hover:bg-sky-100/50">
        <SongComponents.ro song={@song} />
        <SongComponents.description song={@song} />
        <div class="flex gap-0 sm:gap-4 items-center">
          <.shortlist_button id={@song.id} active={@song.shortlisted} />
          <.nope_button id={@song.id} active={@song.noped} />
        </div>
      </div>
    </div>
    """
  end

  defp shortlist_button(assigns) do
    ~H"""
    <button
      phx-click="shortlist"
      phx-value-id={@id}
      class={[
        "border border-transparent py-2 px-3 hover:border-green-500 hover:text-green-600 active:text-green-600",
        if(@active,
          do: "bg-green-300 text-green-700 py-2 px-3 rounded-lg hover:bg-green-300",
          else: "text-green-500 bg-transparent hover:bg-transparent"
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
        "border border-transparent rounded-lg py-2 px-3 hover:border-red-700 hover:text-red-600 active:text-red-600",
        if(@active,
          do: "bg-red-200 text-red-700 py-2 px-3 hover:bg-red-200",
          else: "text-red-600 bg-white/10 hover:bg-transparent"
        )
      ]}
    >
      <.icon name="hero-hand-thumb-down" class="w-8 h-8" />
    </button>
    """
  end
end
