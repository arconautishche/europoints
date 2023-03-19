defmodule PointexWeb.Home do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto flex flex-col mt-20 gap-8 my-auto">
      <.button>Join Watch Party</.button>
      <.navigate to={~p"/wp/new"} class="place-self-center">New Watch Party</.navigate>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)

    {:ok, socket}
  end
end
