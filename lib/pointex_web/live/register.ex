defmodule PointexWeb.Register do
  alias Ecto.UUID
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="rounded bg-white/50 border border-gray-200 pb-10 px-4 sm:px-6 md:px-8 w-full sm:w-3/4 md:w-2/3 mx-auto">
      <p class="mt-4 opacity-75 font-light text-xl text-center">👋 Hey there!</p>

      <.simple_form :let={f} for={@register_params} as={:register_params} phx-change="validate" action={~p"/register?return_to=#{@return_to}"}>
        <.input field={f[:user_id]} type="hidden" />
        <.input field={f[:user_name]} placeholder="What's your name?" />
        <:actions>
          <.button class="grow" disabled={!@valid?} type="submit">Let me in</.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, %{"user" => %{user_id: _}}, socket) do
    return_to = Map.get(params, "return_to", ~p"/")
    {:ok, push_navigate(socket, to: return_to)}
  end

  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Register")
     |> assign(register_params: %{"user_id" => UUID.generate()})
     |> assign(valid?: false)
     |> assign(return_to: Map.get(params, "return_to", ~p"/"))}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"register_params" => register_params}, socket) do
    {:noreply,
     socket
     |> assign(valid?: valid?(register_params))}
  end

  defp valid?(register_params) do
    user_id = Map.get(register_params, "user_id", "")
    user_name = Map.get(register_params, "user_name", "")

    user_id != "" && user_name != ""
  end
end
