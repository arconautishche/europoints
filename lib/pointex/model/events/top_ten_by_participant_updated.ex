defmodule Pointex.Model.Events.TopTenByParticipantUpdated do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :participant_id, :top_ten]
end
