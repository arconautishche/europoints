defmodule PointexWeb.WatchParty.SongComponents do
  use PointexWeb, :html
  alias Pointex.Europoints.Song
  alias Pointex.Europoints.Participant

  def prepare(%Song{} = song, show_kind, %Participant{} = participant) do
    song
    |> Map.take([:year, :country, :flag, :img, :name, :artist])
    |> Map.put(:id, song.country)
    |> Map.put(
      :order,
      case show_kind do
        :semi_final_1 -> song.order_in_sf1
        :semi_final_2 -> song.order_in_sf2
        :final -> song.order_in_final
      end
    )
    |> Map.put(:shortlisted, song.country in participant.shortlist)
    |> Map.put(:noped, song.country in participant.noped)
    |> Map.put(
      :points,
      participant.top_10_with_points
      |> Enum.filter(fn {_points, country} -> country == song.country end)
      |> Enum.map(fn {points, _country} -> points end)
      |> List.first()
    )
  end

  def song_container(assigns) do
    ~H"""
    <div class="relative h-36 grow flex flex-col">
      <div class="absolute w-full h-full opacity-50 overflow-clip">
        <img src={@song.img} class="object-cover w-full sm:max-w-sm md:ml-12" />
      </div>
      <div class="absolute w-full h-full bg-gradient-to-b from-white/70 via-white/30 to-white/50" />
      <div class="relative grow">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :song, :map, required: true
  attr :class, :any, default: ""

  def description(assigns) do
    ~H"""
    <div class={"relative grow " <> @class}>
      <div class="relative flex flex-col gap-2">
        <div class="flex gap-2">
          <div class="text-4xl">
            <%= @song.flag %>
          </div>
          <div class="text-xl pt-1">
            <%= @song.id %>
          </div>
        </div>
        <div class="flex flex-col gap-2 ml-6">
          <div class="flex gap-2 items-center text-black/80">
            <.icon name="hero-microphone" class="text-sky-400 w-4 h-4" />
            <%= @song.artist %>
          </div>
          <div class="flex gap-2 items-center text-black/80">
            <.icon name="hero-musical-note" class="text-sky-400 w-4 h-4" />
            <%= @song.name %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def ro(assigns) do
    ~H"""
    <div class="w-8 font-bold text-black/25 text-3xl">
      <%= @song.order %>
    </div>
    """
  end
end
