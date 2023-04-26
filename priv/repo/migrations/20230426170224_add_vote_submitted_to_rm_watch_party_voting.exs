defmodule Pointex.Repo.Migrations.AddVoteSubmittedToRmWatchPartyVoting do
  use Ecto.Migration

  def change do
    alter table("watch_party_voting") do
      add :vote_submitted, :boolean
    end
  end
end
