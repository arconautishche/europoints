defmodule PointexWeb.WatchParty.RealResults do
  use PointexWeb, :live_view
  alias Pointex.Model.PossiblePoints
  alias Pointex.Model.ReadModels.WatchPartyResults
  alias PointexWeb.WatchParty.Nav
  alias Pointex.Model.Commands

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Nav.layout wp_id={@wp_id} active={nil}>
      <.simple_form for={@real_points} phx-submit="submit" class="mt-4">
        <div :for={point <- PossiblePoints.desc()} class="text-xl">
          <div class="flex flex-row gap-2 justify-stretch">
            <span class="w-8"><%= point %></span>
            <div class="grow">
              <.input type="select" name={point} options={@songs} value={nil} prompt="..." />
            </div>
          </div>
        </div>

        <:actions>
          <.button type="submit">Post</.button>
        </:actions>
      </.simple_form>
    </Nav.layout>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    {:noreply,
     assign(socket, %{
       wp_id: wp_id,
       real_points: %{},
       songs: WatchPartyResults.get(wp_id).songs |> Enum.map(& {"#{&1.details["flag"]} #{&1.details["country"]}", &1.details["country"]})
     })}
  end

  @impl Phoenix.LiveView
  def handle_event("submit", params, socket) do
    :ok =
      Commands.PostRealResults.dispatch_new(%{
        watch_party_id: socket.assigns.wp_id,
        points: params
      })

    {:noreply, socket}
  end
end
