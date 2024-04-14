defmodule Pointex.Model.Router do
  use Commanded.Commands.Router
  alias Pointex.Model.Aggregates
  alias Pointex.Model.Commands

  dispatch(Commands.ToggleSongShortlisted, to: Aggregates.WatchParty, identity: :watch_party_id)
  dispatch(Commands.ToggleSongNoped, to: Aggregates.WatchParty, identity: :watch_party_id)
  dispatch(Commands.GivePointsToSong, to: Aggregates.WatchParty, identity: :watch_party_id)

  dispatch(Commands.FinalizeParticipantsVote,
    to: Aggregates.WatchParty,
    identity: :watch_party_id
  )

  dispatch(Commands.PostRealResults, to: Aggregates.WatchParty, identity: :watch_party_id)
end
