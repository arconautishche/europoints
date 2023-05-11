defmodule PointexWeb.WatchParty.Join do
  use PointexWeb, :live_view
  alias PointexWeb.Components.ShowLabel
  alias Pointex.Model.ReadModels.MyWatchParties
  alias Pointex.Model.Commands

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 sm:rounded sm:border border-gray-200 sm:shadow max-w-md mx-auto overflow-clip">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="flex flex-col gap-4 p-4 sm:p-6 md:p-8 ">
        <div class="flex items-baseline gap-4 opacity-75 font-light text-xl text-center">
          <span>📺</span>
          <span :if={!@watch_party_details}>Join a watch party</span>
          <span :if={@watch_party_details}>You're about to join</span>
        </div>

        <.watch_party_card :if={@watch_party_details} watch_party={@watch_party_details} />

        <.simple_form
          :let={f}
          for={@watch_party}
          as={:watch_party}
          phx-change="validate"
          phx-submit="submit"
        >
          <.input
            field={f[:id]}
            placeholder="Enter the ID you've received"
            autocomplete="off"
            input_class={if @watch_party_details, do: "bg-green-100 !text-xs", else: ""}
          />

          <:actions>
            <.button class="grow" disabled={!@valid?} type="submit">Let's do this!</.button>
          </:actions>
        </.simple_form>
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Join a party")
     |> assign(watch_party: %{"id" => nil})
     |> assign(valid?: false)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    case params do
      %{"id" => wp_id} ->
        {:noreply, assign(socket, found_wp_details(wp_id))}

      _ ->
        {:noreply, assign(socket, found_wp_details(nil))}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("validate", user_input, socket) do
    case Commands.JoinWatchParty.new(command_params_from(user_input, socket.assigns)) do
      {:ok, command} ->
        {:noreply, assign(socket, found_wp_details(command.id))}

      {:errors, _} ->
        {:noreply, assign(socket, valid?: false)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("submit", user_input, socket) do
    %{id: wp_id} = params = command_params_from(user_input, socket.assigns)

    case Commands.JoinWatchParty.dispatch_new(params) do
      :ok ->
        {:noreply, push_navigate(socket, to: ~p"/wp/#{wp_id}/viewing")}

      {:errors, _} ->
        {:noreply, assign(socket, valid?: false)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("select_show", params, socket) do
    show = String.to_existing_atom(params["show"])

    {:noreply, assign(socket, selected_show: show)}
  end

  defp found_wp_details(wp_id) do
    wp_by_id = MyWatchParties.by_id(wp_id)

    %{
      watch_party: %{"id" => wp_id},
      watch_party_details: wp_by_id,
      valid?: wp_by_id != nil
    }
  end

  defp command_params_from(user_input, assigns) do
    %{"watch_party" => %{"id" => id}} = user_input

    %{
      id: id,
      participant_id: user(assigns).id
    }
  end

  defp watch_party_card(assigns) do
    ~H"""
    <div class="w-full flex flex-col gap-4 max-w-lg bg-white shadow rounded p-3 sm:py-4 sm:px-6 cursor-pointer transition">
      <div class="flex gap-2 sm:gap-4 items-top">
        <.icon name="hero-user-group" class="text-sky-700 h-8 w-8 mt-1" />
        <div class="flex flex-col gap-2">
          <h2><%= @watch_party.name %></h2>
          <ShowLabel.show_label year={@watch_party.year} show_name={@watch_party.show} />

          <div class="flex gap-2 flex-wrap text-gray-500 mt-4">
            <.participant
              :for={participant <- @watch_party.other_participants}
              name={participant.name}
            />
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp participant(assigns) do
    ~H"""
    <div class="flex items-center gap-1 rounded bg-gray-100 px-1">
      <.icon name="hero-user" class="text-sky-700 h-3 w-3" />
      <span><%= @name %></span>
    </div>
    """
  end
end
