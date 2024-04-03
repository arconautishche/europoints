defmodule Pointex.Repo.Migrations.RemoveNameFromParticipants do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:ash_participants) do
      remove :name
    end
  end

  def down do
    alter table(:ash_participants) do
      add :name, :text, null: false
    end
  end
end