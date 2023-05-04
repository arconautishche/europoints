defmodule PointexWeb.WatchParty.SongComponents do
  use PointexWeb, :html
  import Pointex.Model.ReadModels.Shows

  def song_container(assigns) do
    ~H"""
    <div class="relative h-36 grow flex flex-col">
      <div class="absolute w-full h-full opacity-50 overflow-clip">
        <img src={song_details(@song.id)[:img]} class="object-cover w-full" />
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
      <div class="relative flex gap-2">
        <div class="text-4xl">
          <%= song_details(@song.id).flag %>
        </div>
        <div class="flex flex-col gap-2">
          <div class="text-xl pt-1">
            <%= @song.id %>
          </div>
          <div class="flex flex-col gap-2">
            <div class="flex gap-2 items-center text-black/80">
              <.icon name="hero-microphone" class="text-sky-400 w-4 h-4" />
              <%= song_details(@song.id).artist %>
            </div>
            <div class="flex gap-2 items-center text-black/80">
              <.icon name="hero-musical-note" class="text-sky-400 w-4 h-4" />
              <%= song_details(@song.id).song %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def ro(assigns) do
    ~H"""
    <div class="w-8 font-bold text-black/25 text-3xl">
      <%= @song.details["ro"] %>
    </div>
    """
  end
end
