defmodule PointexWeb.UserList do
  use PointexWeb, :live_view
  alias Pointex.Europoints.Account

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-2 font-mono max-w-fit">
      <%= for user <- @all_users do %>
        <span>{user.name}</span>
        <span>{user.id}</span>
      <% end %>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, %{
       page_title: "Accounts",
       all_users: Ash.read!(Account)
     })}
  end
end
