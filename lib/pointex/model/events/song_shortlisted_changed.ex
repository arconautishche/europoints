defmodule Pointex.Model.Events.SongShortlistedChanged do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :participant_id, :song_id, :shortlisted]
end
