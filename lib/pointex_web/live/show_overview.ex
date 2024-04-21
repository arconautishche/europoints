defmodule PointexWeb.ShowOverview do
  alias Pointex.Europoints
  alias Pointex.Europoints.Show
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns =
      assign(assigns,
        final: assigns.show.kind == :final,
        show_name:
          case assigns.show.kind do
            :semi_final_1 -> "#{assigns.show.year} - Semi Final 1"
            :semi_final_2 -> "#{assigns.show.year} - Semi Final 2"
            :final -> "#{assigns.show.year} - FINAL"
          end
      )

    ~H"""
    <div>
      <h1 class="text-center text-2xl text-slate-800"><%= @show_name %></h1>
      <div class="mx-4 sm:mx-10">
        <%= if @final do %>
          <span class="my-2 text-slate-600">The actual TOP 10</span>
          <div class="grid grid-cols-12 text-sm items-center mt-8 mb-0">
            <span class="col-span-2 w-12">Place</span>
            <span class="col-span-10 mx-4">Country</span>
          </div>
          <div class="flex flex-col divide-y divide-slate-200">
            <.simple_form :for={form <- @song_forms} for={form} phx-change="update" class="even:bg-slate-100">
              <div class="grid grid-cols-12 text-lg my-2 items-center">
                <div class="col-span-2 w-16"><.input field={form[:actual_place_in_final]} type="number" min="1" max="10" phx-debounce="blur" class="!py-1 !px-2" /></div>
                <div class="col-span-1 mx-4 justify-self-start"><%= form[:flag].value %></div>
                <div class="col-span-9"><%= form[:country].value %></div>
              </div>
            </.simple_form>
          </div>
        <% else %>
          <span class="my-2 text-slate-600">Who's actually going to the Final?</span>
          <.simple_form :for={form <- @song_forms} for={form} phx-change="update">
            <div class="grid grid-cols-12 text-lg my-2 items-center">
              <div class="col-span-1"><.input type="checkbox" field={form[:went_to_final]} class="w-4 h-4" /></div>
              <div class="col-span-1"><%= form[:flag].value %></div>
              <div class="col-span-10"><%= form[:country].value %></div>
            </div>
          </.simple_form>
        <% end %>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"year" => year, "kind" => kind}, _uri, socket) do
    {:noreply,
     socket
     |> assign(year: year)
     |> assign(kind: kind)
     |> assign(load_data(year, kind))}
  end

  @impl Phoenix.LiveView
  def handle_event("update", %{"_target" => [country, _]} = params, socket) do
    form = Enum.find(socket.assigns.song_forms, &(&1.name == country))

    {:ok, _} = AshPhoenix.Form.submit(form, params: params[country] |> dbg())

    {:noreply, assign(socket, load_data(socket.assigns.year, socket.assigns.kind))}
  end

  defp load_data(year, kind) do
    {:ok, %{songs: songs} = show} =
      Show
      |> Europoints.get(year: year, kind: kind)
      |> Europoints.load(:songs)

    action =
      if show.kind == :final do
        :set_actual_place_in_final
      else
        :went_to_final
      end

    %{
      show: show,
      song_forms:
        songs
        |> Enum.sort_by(& &1.country)
        |> Enum.map(
          &(&1
            |> AshPhoenix.Form.for_update(action, api: Europoints, as: &1.country)
            |> to_form())
        )
    }
  end
end
