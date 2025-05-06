defmodule PointexWeb.ChangeAccountName do
  alias Ecto.UUID
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="rounded bg-white/50 border border-gray-200 pb-10 px-4 sm:px-6 md:px-8 w-full sm:w-3/4 md:w-2/3 mx-auto">
      <p class="mt-4 opacity-75 font-light text-xl text-center">👋 Just one more thing...</p>
      <p class="mt-4 opacity-50 font-light text-center">Let's finish setting up your account, how should everyone see you?</p>

      <.simple_form :let={f} for={@form} phx-change="validate" phx-submit="save">
        <.input field={f[:user_id]} type="hidden" />
        <.input field={f[:name]} placeholder="What's your name?" />
        <:actions>
          <.button class="grow" disabled={!@form.valid?} type="submit">Let me in</.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Your name")
     |> assign(form: AshPhoenix.Form.for_update(socket.assigns.current_account, :change_name))}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply,
     socket
     |> assign(form: AshPhoenix.Form.validate(socket.assigns.form, params))}
  end

  def handle_event("save", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _} ->
        {:noreply, push_navigate(socket, to: ~p"/")}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
