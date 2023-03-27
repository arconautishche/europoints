defmodule Pointex.Model.ReadModels.MyWatchPartiesProjector do
  use Commanded.Projections.Ecto,
    application: Pointex.Commanded.Application,
    repo: Pointex.Repo,
    name: "my_watch_parties"

    alias Pointex.Model.Events
    alias Pointex.Model.ReadModels.MyWatchParties

  project(%Events.WatchPartyStarted{} = event, fn multi ->
    %{owner_id: owner_id, id: id, name: name} = event
    Ecto.Multi.insert(multi, :my_watch_parties, %MyWatchParties{id: id, participant_id: owner_id, name: name})
  end)

end
