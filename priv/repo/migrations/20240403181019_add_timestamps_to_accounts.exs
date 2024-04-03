defmodule Pointex.Repo.Migrations.AddTimestampsToAccounts do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:ash_accounts) do
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")
    end
  end

  def down do
    alter table(:ash_accounts) do
      remove :updated_at
      remove :inserted_at
    end
  end
end