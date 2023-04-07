defmodule Pointex.Commanded.Util do
  alias Pointex.Commanded.EventStore
  alias Pointex.Repo

  def reset_projection(name) do
    Repo.query("""
          truncate table
            #{name}
          restart identity;
    """) |> IO.inspect()

    Repo.query("delete from projection_versions where projection_name = '#{name}'") |> IO.inspect()

    EventStore.delete_subscription("$all", name) |> IO.inspect()
  end
end
