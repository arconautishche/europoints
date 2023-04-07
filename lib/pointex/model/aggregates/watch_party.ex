defmodule Pointex.Model.Aggregates.WatchParty do
  defstruct [:id, :name, :owner_id, :year, :show, :participants]

  alias Pointex.Model.Commands
  alias Pointex.Model.Events

  def execute(%__MODULE__{id: nil}, %Commands.StartWatchParty{} = command) do
    %Events.WatchPartyStarted{
      id: command.id,
      name: command.name,
      owner_id: command.owner_id,
      year: command.year,
      show: command.show
    }
  end

  def execute(%__MODULE__{}, %Commands.StartWatchParty{}) do
    {:error, :already_started}
  end

  def execute(%__MODULE__{} = watch_party, %Commands.ShortlistSong{} = command) do
    if command.participant_id in watch_party.participants do
      %Events.SongShortlisted{
        watch_party_id: command.watch_party_id,
        participant_id: command.participant_id,
        song_id: command.song_id
      }
    else
      {:error, :unknown_participant}
    end
  end

  def execute(%__MODULE__{} = watch_party, %Commands.NopeSong{} = command) do
    if command.participant_id in watch_party.participants do
      %Events.SongNoped{
        watch_party_id: command.watch_party_id,
        participant_id: command.participant_id,
        song_id: command.song_id
      }
    else
      {:error, :unknown_participant}
    end
  end

  # state mutators

  def apply(%__MODULE__{} = watch_party, %Events.WatchPartyStarted{} = event) do
    %__MODULE__{
      watch_party
      | id: event.id,
        name: event.name,
        owner_id: event.owner_id,
        year: event.year,
        show: event.show,
        participants: [event.owner_id]
    }
  end

  def apply(%__MODULE__{} = watch_party, %Events.SongShortlisted{} = _event) do
    watch_party
  end

  def apply(%__MODULE__{} = watch_party, %Events.SongNoped{} = _event) do
    watch_party
  end
end
