defmodule PointexWeb.WatchParty.Viewing do
  alias Pointex.Model.ReadModels.WatchPartyViewing
  use PointexWeb, :live_view

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
    {:noreply, assign(socket, load_data(wp_id, user(socket).id))}
  end

  defp load_data(wp_id, user_id) do
    read_model = WatchPartyViewing.get(wp_id, user_id) |> IO.inspect()

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
        <.button class="text-green-500 bg-transparent hover:bg-green-300 hover:text-green-700">
          <.icon name="hero-hand-thumb-up" class="w-8 h-8" />
        </.button>
        <.button class="text-red-600 bg-transparent hover:bg-red-200 hover:text-red-700">
          <.icon name="hero-hand-thumb-down" class="w-8 h-8" />
        </.button>
      </div>
    </div>
    """
  end

end
