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
     |> assign(valid?: false)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", user_input, socket) do
    %{"watch_party" => %{"name" => name}} = user_input

    case Commands.StartWatchParty.new(%{
           name: name,
           id: Ecto.UUID.generate(),
           owner_id: user(socket).id
         }) do
      {:ok, _} ->
        {:noreply, assign(socket, valid?: true)}

      {:errors, _} ->
        {:noreply, assign(socket, valid?: false)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("submit", user_input, socket) do
    %{"watch_party" => %{"name" => name}} = user_input

    case Commands.StartWatchParty.dispatch_new(%{
           name: name,
           id: Ecto.UUID.generate(),
           owner_id: user(socket).id
         }) do
      :ok ->
        {:noreply, push_navigate(socket, to: ~p"/")}

      {:errors, _} ->
        {:noreply, assign(socket, valid?: false)}
    end
  end
end
