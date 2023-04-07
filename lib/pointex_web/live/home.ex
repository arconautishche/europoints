defmodule PointexWeb.Home do
  use PointexWeb, :live_view
  alias Pointex.Model.ReadModels.MyWatchParties
  alias PointexWeb.Components.ShowLabel

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col md:flex-row justify-stretch gap-4 md:gap-8 p-4">
      <.my_watch_parties :if={@user} my_watch_parties={@my_watch_parties} />

      <div class="flex flex-col gap-2 w-full">
        <h1 class="uppercase text-gray-400">Don't have one yet?</h1>
        <div class={[
          "w-full flex flex-col gap-4 max-w-md bg-white shadow rounded p-4 sm:p-6 md:p-8",
          if(@user, do: "", else: "mx-auto")
        ]}>
          <.button>Join Watch Party</.button>
          <.button navigate_to={~p"/wp/new"} kind="secondary">
            New Watch Party
          </.button>
        </div>
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
    <div class="w-full flex flex-col gap-2">
      <h1 class="uppercase text-gray-400">My Watch Parties</h1>

      <div :for={wp <- @my_watch_parties}>
        <.watch_party_card watch_party={wp} />
      </div>
    </div>
    """
  end

  defp watch_party_card(assigns) do
    ~H"""
    <.link navigate={~p"/wp/#{@watch_party.id}/viewing"} class="w-full flex flex-col gap-4 max-w-md bg-white shadow rounded p-4 px-6 cursor-pointer transition hover:bg-amber-100/50 hover:scale-105">
      <div class="flex gap-4 items-center">
        <.icon name="hero-user-group" class="text-sky-700 h-8 w-8" />
        <div class="flex flex-col gap-2">
          <h2><%= @watch_party.name %></h2>
          <ShowLabel.show_label year={@watch_party.year} show_name={@watch_party.show} />
        </div>
      </div>
    </.link>
    """
  end
end