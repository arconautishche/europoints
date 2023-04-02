defmodule PointexWeb.LoginController do
  alias Pointex.Model.ReadModels
  alias Pointex.Model.Commands
  use PointexWeb, :controller

  def register(conn, %{"register_params" => register_params, "return_to" => return_to}) do
    case register(register_params) do
      :ok ->
        conn
        |> Plug.Conn.put_session("user", %{
          user_id: register_params["user_id"],
          user_name: register_params["user_name"]
        })
        |> redirect(to: return_to)

      {:error, :invalid_params} ->
        redirect(conn, to: ~p"/register")
    end
  end

  def login(conn, %{"login_params" => login_params, "return_to" => return_to}) do
    case find_existing_participant(login_params) do
      %{id: id, name: name} ->
        conn
        |> Plug.Conn.put_session("user", %{
          user_id: id,
          user_name: name
        })
        |> redirect(to: return_to)

      :not_found ->
        redirect(conn, to: ~p"/login")
    end
  end

  def logout(conn, _) do
    conn
    |> Plug.Conn.put_session("user", nil)
    |> redirect(to: ~p"/")
  end

  defp register(register_params) do
    user_id = Map.get(register_params, "user_id", "")
    user_name = Map.get(register_params, "user_name", "")

    case Commands.RegisterParticipant.dispatch_new(%{
           pool_id: "default",
           id: user_id,
           name: user_name
         }) do
      :ok -> :ok
      {:errors, _} -> {:error, :invalid_params}
    end
  end

  defp find_existing_participant(login_params) do
    user_id = Map.get(login_params, "user_id", "")

    ReadModels.Participants.find(user_id)
  end
end
