defmodule PointexWeb.WatchParty.Nav do
  use PointexWeb, :html

  def nav(assigns) do
    ~H"""
    <div class="flex">
      <.link
        navigate={~p"/wp/#{@wp_id}"}
        class="self-end -mt-20 mb-8 bg-amber-100 px-8 py-2 rounded-t text-amber-700 mx-auto hover:text-amber-900 hover:bg-amber-50 border-t hover:border-t-gray-500/50 hover:scale-105 origin-bottom transition-all"
      >
        Invite others!
      </.link>
    </div>
    <div class={[
      "sticky z-10",
      if(@mobile,
        do: "sm:hidden bottom-0 shadow-[0px_-8px_18px_0px_rgba(0,0,0,0.1)]",
        else: "hidden sm:block top-0 shadow-lg"
      )
    ]}>
      <div class="grid grid-cols-3 divide-x divide-gray-300 border border-gray-300 backdrop-blur-sm">
        <.nav_item to={~p"/wp/#{@wp_id}/viewing"} label="📺 Viewing" active={@active == :viewing} />
        <.nav_item to={~p"/wp/#{@wp_id}/voting"} label="🗳️ Voting" active={@active == :voting} />
        <.nav_item to={~p"/wp/#{@wp_id}/results"} label="🏁 Results" active={@active == :results} />
      </div>
    </div>
    """
  end

  defp nav_item(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "text-center py-4",
        if(@active, do: "bg-amber-300/70 text-gray-900/80", else: "bg-gray-200/70 text-gray-600")
      ]}
    >
      <%= @label %>
    </.link>
    """
  end
end
