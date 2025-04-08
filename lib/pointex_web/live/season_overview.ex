defmodule PointexWeb.SeasonOverview do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center p-4">
      <h1 class="text-center text-2xl text-slate-800 mb-6">Eurovision {@year} Season Overview</h1>

      <div class="flex flex-col gap-4 w-full max-w-md">
        <.page_link destination={~p"/season/#{@year}/songs"} label="Manage Songs" />
        <h2 class="text-center text-lg font-bold">Results</h2>
        <.show_link year={@year} kind="semi_final_1" label="Semi Final 1" />
        <.show_link year={@year} kind="semi_final_2" label="Semi Final 2" />
        <.show_link year={@year} kind="final" label="Grand Final" />
      </div>
    </div>
    """
  end

  defp page_link(assigns) do
    ~H"""
    <.link navigate={@destination} class="flex items-center justify-between p-4 bg-white shadow rounded hover:bg-sky-100 transition">
      <span class="text-lg">{@label}</span>
      <.icon name="hero-arrow-right" class="h-5 w-5 text-sky-700" />
    </.link>
    """
  end

  defp show_link(assigns) do
    ~H"""
    <.page_link destination={~p"/show/#{@year}/#{@kind}"} label={@label} />
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"year" => year}, _uri, socket) do
    {:noreply,
     socket
     |> assign(page_title: "Season Overview")
     |> assign(year: year)}
  end

  # Handle the old route format for backward compatibility
  @impl Phoenix.LiveView
  def handle_params(%{"year" => year, "kind" => _kind}, _uri, socket) do
    {:noreply,
     socket
     |> assign(page_title: "Season Overview")
     |> assign(year: year)}
  end
end
