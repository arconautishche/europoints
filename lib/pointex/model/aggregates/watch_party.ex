defmodule Pointex.Model.Aggregates.WatchParty do
  defstruct [:id, :name, :owner_id, :year, :show]

  alias Pointex.Model.Commands
  alias Pointex.Model.Events

  def execute(%__MODULE__{id: nil}, %Commands.StartWatchParty{} = command) do
    %Events.WatchPartyStarted{id: command.id, name: command.name, owner_id: command.owner_id, year: command.year, show: command.show}
  end

  def execute(%__MODULE__{}, %Commands.StartWatchParty{}) do
    {:error, :already_started}
  end

  # state mutators

  def apply(%__MODULE__{} = watch_party, %Events.WatchPartyStarted{} = event) do
    %__MODULE__{watch_party | id: event.id, name: event.name, owner_id: event.owner_id, year: event.year, show: event.show}
  end
end
