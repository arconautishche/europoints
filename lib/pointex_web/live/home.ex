defmodule PointexWeb.Home do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto flex flex-col md:-mt-10 gap-4 max-w-md bg-white shadow rounded p-4 sm:p-6 md:p-8">
      <.button>Join Watch Party</.button>
      <.button navigate_to={~p"/wp/new"} kind="secondary">
        New Watch Party
      </.button>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)

    {:ok, socket}
  end
end
