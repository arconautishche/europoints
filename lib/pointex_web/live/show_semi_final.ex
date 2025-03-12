defmodule PointexWeb.ShowSemiFinal do
  alias Pointex.Europoints
  alias Pointex.Europoints.Show
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns =
      assign(assigns,
        show_name:
          case assigns.show.kind do
            :semi_final_1 -> "#{assigns.show.year} - Semi Final 1"
            :semi_final_2 -> "#{assigns.show.year} - Semi Final 2"
            _ -> "#{assigns.show.year}"
          end
      )

    ~H"""
    <div>
      <h1 class="text-center text-2xl text-slate-800">{@show_name}</h1>
      <div class="mx-1 sm:mx-8">
        <span class="my-2 text-slate-600">Who's actually going to the Final?</span>
        <.simple_form :for={form <- @song_forms} for={form} phx-change="update">
          <div class="grid grid-cols-12 text-lg my-2 items-center">
            <div class="col-span-1"><.input type="checkbox" field={form[:went_to_final]} class="w-4 h-4" /></div>
            <div class="col-span-1">{form[:flag].value}</div>
            <div class="col-span-10">{form[:country].value}</div>
          </div>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"year" => year, "kind" => kind}, _uri, socket) do
    {:noreply,
     socket
     |> assign(page_title: "Show Admin")
     |> assign(year: year)
     |> assign(kind: kind)
     |> assign(load_data(year, kind))}
  end

  @impl Phoenix.LiveView
  def handle_event("update", %{"_target" => [country, _]} = params, socket) do
    form = Enum.find(socket.assigns.song_forms, &(&1.name == country))

    {:ok, _} = AshPhoenix.Form.submit(form, params: params[country])

    {:noreply, assign(socket, load_data(socket.assigns.year, socket.assigns.kind))}
  end

  defp load_data(year, kind) do
    {:ok, %{songs: songs} = show} = Ash.get(Show, [year: year, kind: kind], load: [:songs])

    sorted_songs =
      songs
      |> Enum.sort_by(& &1.country)

    %{
      show: show,
      songs: sorted_songs,
      song_forms:
        sorted_songs
        |> Enum.map(
          &(&1
            |> AshPhoenix.Form.for_update(:went_to_final, api: Europoints, as: &1.country)
            |> to_form())
        )
    }
  end
end
