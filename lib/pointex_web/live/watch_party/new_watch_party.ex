defmodule PointexWeb.WatchParty.New do
  use PointexWeb, :live_view
  alias Pointex.Europoints
  alias Pointex.Europoints.WatchParty

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-br from-white to-sky-100/50 sm:rounded sm:border border-gray-200 sm:shadow max-w-md mx-auto overflow-clip">
      <div class="h-[6px] w-full bg-sky-600" />
      <div class="flex flex-col gap-4 p-4 sm:p-6 md:p-8 ">
        <div class="flex items-baseline gap-4 opacity-75 font-light text-xl text-center">
          <span>📺</span>
          <span class="">Let's start a watch party</span>
        </div>

        <.simple_form for={@watch_party} phx-change="validate" phx-submit="submit">
          <.input field={@watch_party[:name]} placeholder="What shall we call it?" autocomplete="off" />
          <.input type="hidden" field={@watch_party[:owner_account_id]} />

          <.show_selector seasons={@seasons} field={@watch_party[:show_id]} />

          <:actions>
            <.button class="grow" disabled={!@watch_party.source.valid?} type="submit">
              Let's do this!
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </section>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    user = user(socket)
    seasons = Europoints.Season.active!()

    default_show_id =
      seasons
      |> Enum.flat_map(& &1.shows)
      |> Enum.find(&(&1.kind == :semi_final_1))
      |> Map.get(:id)

    {:ok,
     socket
     |> assign(page_title: "New party")
     |> assign(seasons: seasons)
     |> assign(
       :watch_party,
       AshPhoenix.Form.for_create(WatchParty, :start,
         api: Europoints,
         as: "watch_party",
         prepare_source: fn changeset ->
           changeset
           |> Ash.Changeset.set_arguments(%{
             name: "#{user.name}'s party",
             owner_account_id: user.id,
             show_id: default_show_id
           })
         end
       )
       |> to_form()
     )
     |> assign(
       selected_show:
         seasons
         |> Enum.flat_map(& &1.shows)
         |> Enum.find(&(&1.kind == :semi_final_1))
         |> Map.get(:id)
     )
     |> assign(valid?: true)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"watch_party" => params}, socket) do
    validated_form = AshPhoenix.Form.validate(socket.assigns.watch_party, params)

    {:noreply, assign(socket, watch_party: validated_form)}
  end

  @impl Phoenix.LiveView
  def handle_event("submit", %{"watch_party" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.watch_party, params: params) do
      {:ok, wp} ->
        {:noreply, push_navigate(socket, to: ~p"/wp/#{wp.id}")}

      {:error, form} ->
        {:noreply, assign(socket, watch_party: form)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("select_show", params, socket) do
    show = params["show"]

    {:noreply, assign(socket, selected_show: show)}
  end

  defp show_selector(assigns) do
    ~H"""
    <div :for={season <- @seasons} class="flex flex-col gap-4">
      <span class="text-lg opacity-50"><%= season.year %></span>
      <div class="grid grid-rows-3 gap-4">
        <.show_button :for={show <- sort_shows(season.shows)} show={show} field={@field} />
      </div>
    </div>
    """
  end

  defp show_button(assigns) do
    assigns = assign(assigns, selected: assigns.field.value == assigns.show.id)

    ~H"""
    <label class={[
      "flex items-center gap-4",
      "px-4 py-2 text-lg rounded border border-l-4",
      "transition",
      "hover:bg-sky-300",
      if(@selected,
        do:
          "bg-gradient-to-br from-amber-500 to-amber-400 border-amber-600 text-amber-900 shadow-none hover:bg-amber-400",
        else: "border-sky-600 text-sky-900"
      )
    ]}>
      <.icon :if={@selected} name="hero-check-circle" class="w-6 h-6" />
      <div :if={!@selected} class="w-6 h-6" />
      <span class="grow"><%= show_label(@show.kind) %></span>
      <input type="radio" name={@field.name} value={@show.id} checked={@selected} class="hidden" />
    </label>
    """
  end

  defp show_label(:semi_final_1), do: "Semi-final 1"
  defp show_label(:semi_final_2), do: "Semi-final 2"
  defp show_label(:final), do: "Final"

  @show_order %{
    semi_final_1: 1,
    semi_final_2: 2,
    final: 3
  }

  defp sort_shows(shows) do
    Enum.sort_by(shows, &@show_order[&1.kind])
  end
end
