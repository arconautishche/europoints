defmodule Pointex.Repo.Migrations.AddPasswordAuthenticationAndAddPasswordAuth do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:ash_accounts) do
      add :confirmed_at, :utc_datetime_usec
      add :hashed_password, :text
    end
  end

  def down do
    alter table(:ash_accounts) do
      remove :hashed_password
      remove :confirmed_at
    end
  end
end
