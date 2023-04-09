defmodule Pointex.Model.Events.SongNopedChanged do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :participant_id, :song_id, :noped]
end
