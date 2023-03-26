defmodule PointexWeb.UserAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(
        :default,
        _params,
        %{"user" => %{user_id: user_id, user_name: user_name}},
        socket
      ) do
    {:cont, assign(socket, user: %{id: user_id, name: user_name})}
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, user: nil)}
  end

  def on_mount(
        :ensure_logged_in,
        _params,
        %{"user" => %{user_id: _, user_name: _}},
        socket
      ) do
    {:cont, socket}
  end

  def on_mount(:ensure_logged_in, _params, _session, socket) do
    {:halt,
     push_navigate(socket, to: "/login?return_to=#{socket.private.connect_info.request_path}")}
  end
end
