defmodule Pointex.Commanded.Util do
  alias Pointex.Repo

  def reset_all() do
    reset_eventstore!()
    reset_all_projections()
  end

  def reset_all_projections() do
    reset_projection("my_watch_parties")
    reset_projection("participants")
    reset_projection("watch_party_viewing")
    reset_projection("watch_party_voting")
  end

  def reset_projection(name) do
    Repo.query("""
          truncate table
            #{name}
          restart identity;
    """) |> IO.inspect()

    Repo.query("delete from projection_versions where projection_name = '#{name}'") |> IO.inspect()

    Pointex.Commanded.EventStore.delete_subscription("$all", name) |> IO.inspect()
  end

  def reset_eventstore! do
    config = Pointex.Commanded.EventStore.config()

    {:ok, conn} = Postgrex.start_link(config)

    EventStore.Storage.Initializer.reset!(conn, config) |> IO.inspect()
  end
end
