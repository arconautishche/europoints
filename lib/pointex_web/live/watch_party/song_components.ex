defmodule PointexWeb.WatchParty.SongComponents do
  use PointexWeb, :html

  def description(assigns) do
    ~H"""
    <div class="flex gap-2 grow">
      <div class="text-4xl">
        <%= @song.details["flag"] %>
      </div>
      <div class="flex flex-col gap-2">
        <div class="text-xl pt-1">
          <%= @song.details["country"] %>
        </div>
        <div class="flex flex-col gap-2">
          <div class="flex gap-2 items-center text-black/40">
            <.icon name="hero-microphone" class="text-sky-400/50 w-4 h-4" />
            <%= @song.details["artist"] %>
          </div>
          <div class="flex gap-2 items-center text-black/40">
            <.icon name="hero-musical-note" class="text-sky-400/50 w-4 h-4" />
            <%= @song.details["song"] %>
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
