defmodule PointexWeb.Login do
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="rounded bg-white/50 border border-gray-200 pb-10 px-4 sm:px-6 md:px-8 w-full sm:w-3/4 md:w-2/3 mx-auto">
      <p class="mt-4 opacity-75 font-light text-xl text-center">👋 Welcome back!</p>

      <.simple_form :let={f} for={@login_params} as={:login_params} phx-change="validate" action={~p"/login?return_to=#{@return_to}"}>
        <.input field={f[:user_id]} placeholder="Your unique ID?" />
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
     |> assign(page_title: "Login")
     |> assign(login_params: %{})
     |> assign(valid?: false)
     |> assign(return_to: Map.get(params, "return_to", ~p"/"))}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"login_params" => login_params}, socket) do
    {:noreply,
     socket
     |> assign(valid?: valid?(login_params))}
  end

  defp valid?(login_params) do
    user_id = Map.get(login_params, "user_id", "")

    user_id != ""
  end
end
