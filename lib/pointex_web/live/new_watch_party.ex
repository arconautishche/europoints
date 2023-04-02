defmodule PointexWeb.NewWatchParty do
  alias Pointex.Model.Commands
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 rounded sm:border border-gray-200 sm:shadow max-w-md mx-auto overflow-clip">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="flex flex-col gap-4 p-4 sm:p-6 md:p-8 ">
        <div class="flex items-baseline gap-4 opacity-75 font-light text-xl text-center">
          <span>📺</span>
          <span class="">Let's start a watch party</span>
        </div>

        <.simple_form
          :let={f}
          for={@watch_party}
          as={:watch_party}
          phx-change="validate"
          phx-submit="submit"
        >
          <.input field={f[:name]} placeholder="What shall we call it?" autocomplete="off" />

          <.show_selector selected_show={@selected_show} />

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
     |> assign(watch_party: %{})
     |> assign(selected_show: :semi_final_1)
     |> assign(valid?: false)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", user_input, socket) do
    case Commands.StartWatchParty.new(command_params_from(user_input, socket.assigns)) do
      {:ok, command} ->
        {:noreply, assign(socket, %{valid?: true, watch_party: %{"name" => command.name}})}

      {:errors, _} ->
        {:noreply, assign(socket, valid?: false)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("submit", user_input, socket) do
    case Commands.StartWatchParty.dispatch_new(command_params_from(user_input, socket.assigns)) do
      :ok ->
        {:noreply, push_navigate(socket, to: ~p"/")}

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
    %{"watch_party" => %{"name" => name}} = user_input
    %{selected_show: selected_show} = assigns

    %{
      name: name,
      id: Ecto.UUID.generate(),
      owner_id: user(assigns).id,
      year: 2003,
      show: selected_show
    }
  end

  defp show_selector(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <span class="text-lg opacity-50">2023</span>
      <div class="grid grid-rows-3 gap-4">
        <.show_button selected_show={@selected_show} show_name={:semi_final_1} label="Semi-final 1" />
        <.show_button selected_show={@selected_show} show_name={:semi_final_2} label="Semi-final 2" />
        <.show_button selected_show={@selected_show} show_name={:final} label="Final" />
      </div>
    </div>
    """
  end

  defp show_button(assigns) do
    ~H"""
    <button
      phx-click="select_show"
      phx-value-show={@show_name}
      type="button"
      class={[
        "px-4 py-2 text-lg rounded shadow-lg",
        "transition",
        "hover:bg-sky-300",
        if(@selected_show == @show_name,
          do:
            "bg-gradient-to-br from-amber-500 to-amber-400 text-amber-900 shadow-none hover:bg-amber-400",
          else: "bg-sky-200 text-sky-900"
        )
      ]}
    >
      <%= @label %>
    </button>
    """
  end
end
