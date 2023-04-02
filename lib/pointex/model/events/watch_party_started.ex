defmodule Pointex.Model.Events.WatchPartyStarted do
  @derive Jason.Encoder
  defstruct [:id, :name, :owner_id, :year, :show]
end
