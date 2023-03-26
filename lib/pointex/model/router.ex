defmodule Pointex.Model.Router do
  use Commanded.Commands.Router
  alias Pointex.Model.Aggregates
  alias Pointex.Model.Commands

  dispatch Commands.StartWatchParty, to: Aggregates.WatchParty, identity: :id
end
