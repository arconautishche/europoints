defmodule PointexWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in LiveViews.
  """

  import Phoenix.Component
  use PointexWeb, :verified_routes

  # This is used for nested liveviews to fetch the current user.
  # To use, place the following at the top of that liveview:
  # on_mount {PointexWeb.LiveUserAuth, :current_account}
  def on_mount(:current_account, _params, session, socket) do
    dbg(session)
    {:cont, AshAuthentication.Phoenix.LiveSession.assign_new_resources(socket, session) |> dbg()}
  end

  def on_mount(:account_optional, _params, _session, socket) do
    if socket.assigns[:current_account] do
      {:cont, socket}
    else
      {:cont, assign(socket, :current_account, nil)}
    end
  end

  def on_mount(:account_required, _params, _session, socket) do
    if socket.assigns[:current_account] do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end

  def on_mount(:account_with_name_required, _params, _session, socket) do
    case socket.assigns[:current_account] do
      %{name: nil} ->
        {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/account/name")}

      _ ->
        {:cont, socket}
    end
  end

  def on_mount(:no_account, _params, _session, socket) do
    if socket.assigns[:current_account] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont, assign(socket, :current_account, nil)}
    end
  end
end
