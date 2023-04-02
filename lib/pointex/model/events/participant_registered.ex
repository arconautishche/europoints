defmodule Pointex.Model.Events.ParticipantRegistered do
  @derive Jason.Encoder
  defstruct [:id, :name]
end
