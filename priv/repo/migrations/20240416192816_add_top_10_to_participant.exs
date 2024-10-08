defmodule Pointex.Repo.Migrations.AddTop10ToParticipant do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:ash_participants) do
      add :top_10, {:array, :text}, default: "{NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL}"
    end
  end

  def down do
    alter table(:ash_participants) do
      remove :top_10
    end
  end
end
