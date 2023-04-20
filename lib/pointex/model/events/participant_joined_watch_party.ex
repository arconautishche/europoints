defmodule Pointex.Model.Events.ParticipantJoinedWatchParty do
  @derive Jason.Encoder
  defstruct [:id, :participant_id, :name, :owner_id, :year, :show]
end
