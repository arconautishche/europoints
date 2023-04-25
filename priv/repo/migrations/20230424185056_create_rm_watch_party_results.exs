defmodule Pointex.Repo.Migrations.CreateRmWatchPartyResults do
  use Ecto.Migration

  def change do
    create table("watch_party_results", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :songs, :map
      add :predictions_top, :map

      timestamps()
    end
  end
end
