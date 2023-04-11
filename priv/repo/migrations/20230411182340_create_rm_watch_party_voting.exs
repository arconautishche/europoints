defmodule Pointex.Repo.Migrations.CreateRmWatchPartyVoting do
  use Ecto.Migration

  def change do
    create table("watch_party_voting", primary_key: false) do
      add :id, :binary_id
      add :participant_id, :binary_id
      add :songs, :map

      timestamps()
    end
  end
end
