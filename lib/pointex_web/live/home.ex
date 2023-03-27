defmodule PointexWeb.Home do
  alias Pointex.Model.ReadModels.MyWatchParties
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col md:flex-row justify-stretch gap-4 md:gap-8 p-4">
      <.my_watch_parties :if={@user} my_watch_parties={@my_watch_parties}/>

      <div class={["w-full flex flex-col md:-mt-10 gap-4 max-w-md bg-white shadow rounded p-4 sm:p-6 md:p-8", if(@user, do: "", else: "mx-auto")]}>
        <.button>Join Watch Party</.button>
        <.button navigate_to={~p"/wp/new"} kind="secondary">
          New Watch Party
        </.button>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, my_watch_parties: MyWatchParties.for(user(socket).id))}
  end

  defp my_watch_parties(assigns) do
    ~H"""
    <div class="w-full flex flex-col md:-mt-10 gap-4 max-w-md bg-white shadow rounded p-4 sm:p-6 md:p-8">
      <h1 class="uppercase text-gray-400">My Watch Parties</h1>

      <div :for={wp <- @my_watch_parties}>
        <%= wp.name %>
      </div>
    </div>
    """
  end
end
