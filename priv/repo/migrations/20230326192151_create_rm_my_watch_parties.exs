defmodule Pointex.Repo.Migrations.CreateRmMyWatchParties do
  use Ecto.Migration

  def change do
    create table("my_watch_parties", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :participant_id, :binary_id
      add :name, :string

      timestamps()
    end
  end
end
