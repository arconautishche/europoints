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
      <h1 class="text-center text-2xl text-slate-800">{@show_name}</h1>
      <div class="mx-1 sm:mx-8">
        <%= if @final do %>
          <span class="my-2 text-slate-600">The actual TOP 10</span>
          <div class="flex divide-x divide-slate-200 flex-wrap">
            <div :for={place <- 1..10} class="flex flex-col gap-4">
              <div class="sticky top-0 flex justify-center gap-2 items-center border-b-4 border-sky-700 text-sky-800 px-2 py-1 text-xl font-bold bg-slate-100">
                <.icon name="hero-check" class={["-ml-6 text-green-600", unless(place_filled(@songs, place), do: "invisible")]} />
                <span class="text-center ">{place}</span>
              </div>
              <div class="flex flex-col">
                <button
                  :for={song <- @songs}
                  class={[
                    "flex flex-col gap-0 py-3 items-center transition-all",
                    if(song.actual_place_in_final == place,
                      do: "bg-amber-200",
                      else: "hover:bg-amber-300/25"
                    )
                  ]}
                  phx-click="place_song"
                  phx-value-country={song.country}
                  phx-value-place={place}
                >
                  <span class="-mb-1">{song.flag}</span>
                  <span class="text-sm text-slate-600">{song.country}</span>
                </button>
              </div>
            </div>
          </div>
        <% else %>
          <span class="my-2 text-slate-600">Who's actually going to the Final?</span>
          <.simple_form :for={form <- @song_forms} for={form} phx-change="update">
            <div class="grid grid-cols-12 text-lg my-2 items-center">
              <div class="col-span-1"><.input type="checkbox" field={form[:went_to_final]} class="w-4 h-4" /></div>
              <div class="col-span-1">{form[:flag].value}</div>
              <div class="col-span-10">{form[:country].value}</div>
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

  def handle_event("place_song", %{"country" => country, "place" => place}, socket) do
    songs = socket.assigns.songs

    song = Enum.find(songs, &(&1.country == country))
    song_at_place = Enum.find(songs, &(to_string(&1.actual_place_in_final) == place))
    place_to_set = if to_string(song.actual_place_in_final) == place, do: nil, else: place

    # TODO: this should probably be under Show, where all the logic would happen
    Europoints.Song.set_actual_place_in_final!(song, place_to_set)

    if song_at_place, do: Europoints.Song.set_actual_place_in_final!(song_at_place, nil)

    {:noreply, assign(socket, load_data(socket.assigns.year, socket.assigns.kind))}
  end

  defp load_data(year, kind) do
    {:ok, %{songs: songs} = show} = Ash.get(Show, [year: year, kind: kind], load: [:songs])

    action =
      if show.kind == :final do
        :set_actual_place_in_final
      else
        :went_to_final
      end

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
            |> AshPhoenix.Form.for_update(action, api: Europoints, as: &1.country)
            |> to_form())
        )
    }
  end

  defp place_filled(songs, place) do
    Enum.any?(songs, &(&1.actual_place_in_final == place))
  end
end
