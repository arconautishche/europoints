defmodule PointexWeb.WatchParty.Admin do
  use PointexWeb, :live_view
  alias Pointex.Europoints

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 sm:rounded sm:border border-gray-200 sm:shadow mx-auto overflow-clip font-light">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="px-4 py-2 flex flex-col gap-2">
        <h1 class="text-2xl text-slate-800 border-b border-slate-200">Participants</h1>
        <div :for={participant <- @watch_party.participants} class="flex items-center bg-blue-200/25 px-2 py-1">
          <div class="grow flex flex-col gap-2 items-start">
            <span><%= participant.account.name %></span>
            <span
              :if={length(participant.used_points) == 0 && length(participant.noped) == 0 && length(participant.shortlist) == 0}
              class="bg-red-200 px-2 py-1 text-xs rounded"
            >
              No activity
            </span>
          </div>
          <.button phx-click="remove_participant" phx-value-participant_id={participant.id}>
            Delete
          </.button>
        </div>
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => wp_id}, _uri, socket) do
    watch_party = Ash.get!(Europoints.WatchParty, wp_id, load: [:participants])

    {:noreply,
     socket
     |> assign(page_title: "Share")
     |> assign(%{
       wp_id: wp_id,
       watch_party: watch_party
     })}
  end

  @impl Phoenix.LiveView
  def handle_event("remove_participant", %{"participant_id" => participant_id}, socket) do
    Europoints.WatchParty.leave!(socket.assigns.watch_party, participant_id)

    {:noreply,
     assign(socket,
       watch_party: Ash.get!(Europoints.WatchParty, socket.assigns.wp_id, load: [:participants])
     )}
  end
end
