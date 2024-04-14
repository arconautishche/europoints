defmodule Pointex.Repo.Migrations.RemoveFlagFromSongs do
  use Ecto.Migration

  def up do
    alter table(:songs) do
      remove :flag
    end
  end

  def down do
    alter table(:songs) do
      add :flag, :text, null: false
    end
  end
end
