defmodule Pointex.Repo.Migrations.AddSeasonsAndWatchParties do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:ash_watch_parties, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :name, :text, null: false
    end

    create table(:ash_seasons, primary_key: false) do
      add :year, :bigint, null: false, primary_key: true
    end
  end

  def down do
    drop table(:ash_seasons)

    drop table(:ash_watch_parties)
  end
end