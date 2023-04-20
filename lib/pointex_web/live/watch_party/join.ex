defmodule PointexWeb.WatchParty.Join do
  alias Pointex.Model.Commands
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 sm:rounded sm:border border-gray-200 sm:shadow max-w-md mx-auto overflow-clip">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="flex flex-col gap-4 p-4 sm:p-6 md:p-8 ">
        <div class="flex items-baseline gap-4 opacity-75 font-light text-xl text-center">
          <span>📺</span>
          <span class="">Join a watch party</span>
        </div>

        <.simple_form
          :let={f}
          for={@watch_party}
          as={:watch_party}
          phx-change="validate"
          phx-submit="submit"
        >
          <.input field={f[:id]} placeholder="Enter the ID you've received" autocomplete="off" />

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
     |> assign(watch_party: %{"id" => nil})
     |> assign(valid?: false)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    case params |> IO.inspect() do
      %{"id" => wp_id} ->
        {:noreply,
         socket
         |> assign(watch_party: %{"id" => wp_id})
         |> assign(valid?: true)}

      _ ->
        {:noreply,
         socket
         |> assign(watch_party: %{"id" => nil})
         |> assign(valid?: false)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("validate", user_input, socket) do
    case Commands.JoinWatchParty.new(command_params_from(user_input, socket.assigns)) do
      {:ok, command} ->
        {:noreply, assign(socket, %{valid?: true, watch_party: %{"id" => command.id}})}

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

  defp command_params_from(user_input, assigns) do
    %{"watch_party" => %{"id" => id}} = user_input

    %{
      id: id,
      participant_id: user(assigns).id
    }
  end
end
