defmodule Pointex.Model.Events.SongNoped do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :participant_id, :song_id]
end
