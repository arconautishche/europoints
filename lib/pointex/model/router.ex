defmodule Pointex.Model.Router do
  use Commanded.Commands.Router
  alias Pointex.Model.Aggregates
  alias Pointex.Model.Commands

  dispatch Commands.RegisterParticipant, to: Aggregates.Participants, identity: :pool_id
  dispatch Commands.StartWatchParty, to: Aggregates.WatchParty, identity: :id
  dispatch Commands.ShortlistSong, to: Aggregates.WatchParty, identity: :watch_party_id
  dispatch Commands.NopeSong, to: Aggregates.WatchParty, identity: :watch_party_id
end