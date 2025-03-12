defmodule PointexWeb.ShowFinal do
  alias Pointex.Europoints
  alias Pointex.Europoints.Show
  use PointexWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns =
      assign(assigns,
        show_name: "#{assigns.show.year} - FINAL"
      )

    ~H"""
    <div>
      <h1 class="text-center text-2xl text-slate-800">{@show_name}</h1>
      <div class="mx-1 sm:mx-8">
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
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_params(%{"year" => year}, _uri, socket) do
    {:noreply,
     socket
     |> assign(page_title: "Show Admin")
     |> assign(year: year)
     |> assign(kind: :final)
     |> assign(load_data(year, :final))}
  end

  @impl Phoenix.LiveView
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

    sorted_songs =
      songs
      |> Enum.sort_by(& &1.country)

    %{
      show: show,
      songs: sorted_songs
    }
  end

  defp place_filled(songs, place) do
    Enum.any?(songs, &(&1.actual_place_in_final == place))
  end
end
