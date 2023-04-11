defmodule PointexWeb.WatchParty.Voting do
  use PointexWeb, :live_view
  alias PointexWeb.Endpoint
  alias Pointex.Model.ReadModels.WatchPartyVoting
  alias PointexWeb.WatchParty.Nav
  alias PointexWeb.WatchParty.SongComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="relative">
      <Nav.nav wp_id={@wp_id} mobile={false} active={:voting} />
      <div class="flex flex-col sm:flex-row gap-4 my-2">
        <.top_10 />
        <flex class="flex flex-col gap-4 w-full">
          <.unvoted_section label="👍 Shortlisted" songs={subset(@songs, :shortlisted)} header_class="bg-gradient-to-r from-green-100" />
          <.unvoted_section label="🫤 Undecided" songs={subset(@songs, :meh)} header_class="bg-gradient-to-r from-gray-200" />
          <.unvoted_section label="💩 Noped" songs={subset(@songs, :noped)} header_class="bg-gradient-to-r from-red-100" />
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

  defp load_data(wp_id, user_id) do
    read_model = WatchPartyVoting.get(wp_id, user_id)

    %{wp_id: wp_id, songs: read_model.songs}
  end

  defp subset(songs, viewing_result) do
    Enum.filter(songs, &(&1.points < 1 && &1.viewing_result == viewing_result))
  end

  defp top_10(assigns) do
    ~H"""
    <section>
      <.section_header label="🏅 My TOP 10" class="" />
      <div class="flex flex-col divide-y divide-gray-200 bg-white shadow-lg border border-gray-200">
        <.points_given points="12" song={nil} />
        <.points_given points="10" song={nil} />
        <.points_given points="8" song={nil} />
        <.points_given points="7" song={nil} />
        <.points_given points="6" song={nil} />
        <.points_given points="5" song={nil} />
        <.points_given points="4" song={nil} />
        <.points_given points="3" song={nil} />
        <.points_given points="2" song={nil} />
        <.points_given points="1" song={nil} />
      </div>
    </section>
    """
  end

  defp unvoted_section(assigns) do
    ~H"""
    <section class="w-full">
      <.section_header label={@label} class={@header_class} />
      <div class="flex flex-col divide-y divide-gray-200 my-2">
        <.song_with_no_points :for={song <- @songs} song={song} />
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
    ~H"""
    <div class="flex">
      <.points_label points={@points} active={false} />
      <div class="text-gray-300 px-2 py-2 w-72">No song here (yet)</div>
    </div>
    """
  end

  defp points_label(assigns) do
    ~H"""
    <div class={[
      if(@active, do: "bg-sky-600 text-sky-100", else: "bg-gray-400 text-gray-100 animate-pulse"),
      "font-bold text-2xl w-12 flex items-center justify-center"
    ]}>
      <%= @points %>
    </div>
    """
  end

  defp song_with_no_points(assigns) do
    ~H"""
    <div class="flex items-top justify-between gap-2 px-2 sm:px-4 py-3 hover:bg-sky-100">
      <SongComponents.ro song={@song} />
      <SongComponents.description song={@song} />

    </div>
    """
  end
end
