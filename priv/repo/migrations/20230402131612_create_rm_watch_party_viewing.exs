defmodule Pointex.Repo.Migrations.CreateRmWatchPartyViewing do
  use Ecto.Migration

  def change do
    create table("watch_party_viewing", primary_key: false) do
      add :id, :binary_id
      add :participant_id, :binary_id
      add :songs, :map

      timestamps()
    end
  end
end
