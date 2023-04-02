defmodule Pointex.Model.Aggregates.Participants do
  defstruct [:registered_participants]

  alias Pointex.Model.Commands
  alias Pointex.Model.Events

  def execute(%__MODULE__{}, %Commands.RegisterParticipant{} = command) do
    %Events.ParticipantRegistered{id: command.id, name: command.name}
  end

  # state mutators

  def apply(
        %__MODULE__{registered_participants: nil},
        %Events.ParticipantRegistered{} = event
      ) do
    %__MODULE__{registered_participants: [%{id: event.id, name: event.name}]}
  end

  def apply(
        %__MODULE__{registered_participants: already_registered},
        %Events.ParticipantRegistered{} = event
      ) do
    %__MODULE__{
      registered_participants: already_registered ++ [%{id: event.id, name: event.name}]
    }
  end
end
