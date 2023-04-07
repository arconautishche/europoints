defmodule PointexWeb.WatchParty.Viewing do
  use PointexWeb, :live_view
  alias PointexWeb.Endpoint
  alias Pointex.Model.ReadModels.WatchPartyViewing
  alias Pointex.Model.Commands

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col divide-y divide-gray-200">
      <.song_viewing :for={song <- @songs} song={song} />
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # TODO: protect from prying eyes
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    if connected?(socket), do: Endpoint.subscribe("watch_party_viewing:#{wp_id}")

    {:noreply, assign(socket, load_data(wp_id, user(socket).id))}
  end

  @impl Phoenix.LiveView
  def handle_event("shortlist", %{"id" => song_id}, socket) do
    %{wp_id: wp_id} = socket.assigns

    :ok =
      Commands.ShortlistSong.dispatch_new(%{
        watch_party_id: wp_id,
        participant_id: user(socket).id,
        song_id: song_id
      })

    {:noreply, socket}
  end

  def handle_event("nope", %{"id" => song_id}, socket) do
    %{wp_id: wp_id} = socket.assigns

    :ok =
      Commands.NopeSong.dispatch_new(%{
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
    read_model = WatchPartyViewing.get(wp_id, user_id)

    %{wp_id: wp_id, songs: read_model.songs}
  end

  defp song_viewing(assigns) do
    ~H"""
    <div class="flex items-top justify-between gap-2 px-2 sm:px-4 py-3 hover:bg-sky-100">
      <div class="w-8 opacity-25 font-bold text-3xl">
        <%= @song.details["ro"] %>
      </div>

      <div class="flex gap-2 grow">
        <div class="text-4xl">
          <%= @song.details["flag"] %>
        </div>
        <div class="flex flex-col gap-2">
          <div class="text-xl pt-1">
            <%= @song.details["country"] %>
          </div>
          <div class="flex flex-col gap-2 opacity-50">
            <div class="flex gap-2 items-center">
              <.icon name="hero-microphone" class="text-sky-400 w-4 h-4" />
              <%= @song.details["artist"] %>
            </div>
            <div class="flex gap-2 items-center">
              <.icon name="hero-musical-note" class="text-sky-400 w-4 h-4" />
              <%= @song.details["song"] %>
            </div>
          </div>
        </div>
      </div>

      <div class="flex gap-0 sm:gap-4 items-center">
        <.shortlist_button id={@song.details["country"]} active={@song.shortlisted} />
        <.nope_button id={@song.details["country"]} active={@song.noped} />
      </div>
    </div>
    """
  end

  defp shortlist_button(assigns) do
    ~H"""
    <.button
      phx-click="shortlist"
      phx-value-id={@id}
      class={[
        "border border-transparent hover:border-green-500 hover:bg-transparent hover:text-green-600 active:text-green-600",
        if(@active,
          do: "bg-green-300 text-green-700 py-2 px-3 rounded-lg",
          else: "text-green-500 bg-transparent"
        )
      ]}
    >
      <.icon name="hero-hand-thumb-up" class="w-8 h-8" />
    </.button>
    """
  end

  defp nope_button(assigns) do
    ~H"""
    <.button
      phx-click="nope"
      phx-value-id={@id}
      class={[
        "border border-transparent hover:border-red-700 hover:bg-transparent hover:text-red-600 active:text-red-600",
        if(@active,
          do: "bg-red-200 text-red-700 py-2 px-3 rounded-lg",
          else: "text-red-600 bg-transparent"
        )
      ]}
    >
      <.icon name="hero-hand-thumb-down" class="w-8 h-8" />
    </.button>
    """
  end
end
