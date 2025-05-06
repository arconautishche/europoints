defmodule PointexWeb.LoginController do
  use PointexWeb, :controller
  alias Pointex.Accounts
  alias Pointex.Accounts.Account

  def register(conn, %{"register_params" => register_params, "return_to" => return_to}) do
    name = Map.get(register_params, "user_name", "")
    email = Map.get(register_params, "user_email", "")

    case Accounts.register_account!(name, email) do
      {:ok, account} ->
        conn
        |> Plug.Conn.put_session("user", %{
          user_id: account.id,
          user_name: account.name
        })
        |> redirect(to: return_to)

      {:error, _} ->
        redirect(conn, to: ~p"/register")
    end
  end

  def login(conn, %{"login_params" => login_params, "return_to" => return_to}) do
    case Ash.get(Account, login_params["user_id"]) do
      {:ok, %{id: id, name: name}} ->
        conn
        |> Plug.Conn.put_session("user", %{
          user_id: id,
          user_name: name
        })
        |> redirect(to: return_to)

      _ ->
        redirect(conn, to: ~p"/login")
    end
  end

  def logout(conn, _) do
    conn
    |> Plug.Conn.put_session("user", nil)
    |> redirect(to: ~p"/")
  end
end
