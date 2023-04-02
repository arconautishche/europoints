defmodule Pointex.Repo.Migrations.AddShowInfoToMyWatchParties do
  use Ecto.Migration

  def change do
    alter table("my_watch_parties") do
      add :year, :integer
      add :show, :string
    end
  end
end
