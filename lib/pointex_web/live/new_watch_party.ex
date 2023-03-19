defmodule PointexWeb.NewWatchParty do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto flex flex-col mt-20 gap-8 my-auto">
      New Watch Party
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
