defmodule PointexWeb.LoginController do
  use PointexWeb, :controller

  def post(conn, %{"login_data" => login_data, "return_to" => return_to}) do
    if valid?(login_data) do
      conn
      |> Plug.Conn.put_session("user", %{
        user_id: login_data["user_id"],
        user_name: login_data["user_name"]
      })
      |> redirect(to: return_to)
    else
      redirect(conn, to: ~p"/login")
    end
  end

  defp valid?(login_data) do
    user_id = Map.get(login_data, "user_id", "")
    user_name = Map.get(login_data, "user_name", "")

    user_id != "" && user_name != ""
  end
end
