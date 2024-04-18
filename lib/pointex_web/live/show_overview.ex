defmodule PointexWeb.ShowOverview do
  alias Pointex.Europoints
  alias Pointex.Europoints.Show
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col divide-y divide-slate-200 mt-4 mx-4 sm:mx-10">
      <span class="my-2 text-slate-600">Who's actually going to the Final?</span>
      <.simple_form :for={form <- @song_forms} for={form} phx-change="update" class="">
        <div class="grid grid-cols-12 text-lg my-2">
          <div class="col-span-1 mt-1"><.input type="checkbox" field={form[:went_to_final]} class="w-4 h-4" /></div>
          <div class="col-span-1"><%= form[:flag].value %></div>
          <div class="col-span-10"><%= form[:country].value %></div>
        </div>
      </.simple_form>
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
    {:ok, %{songs: songs}} =
      Show
      |> Europoints.get(year: year, kind: kind)
      |> Europoints.load(:songs)

    %{
      song_forms:
        songs
        |> Enum.sort_by(& &1.country)
        |> Enum.map(
          &(&1
            |> AshPhoenix.Form.for_update(:went_to_final, api: Europoints, as: &1.country)
            |> to_form())
        )
    }
  end
end
