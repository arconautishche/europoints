defmodule Pointex.Europoints.Participant do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  resource do
    description """
    A participant in a `WatchParty`. A user can have multiple `Participant` records - one for each `WatchParty` they've joined.
    """
  end

  attributes do
    uuid_primary_key :id
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  postgres do
    table "ash_participants"
    repo Pointex.Repo
  end
end
