defmodule Pointex.Repo.Migrations.RemoveEmailFromUsers do
  use Ecto.Migration

  def change do
    alter table(:ash_accounts) do
      remove :email
    end
  end
end
