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

  def execute(%__MODULE__{} = watch_party, %Commands.ToggleSongShortlisted{} = command) do
    with %{} = participant <- participant(watch_party, command.participant_id) do
      [
        %Events.SongShortlistedChanged{
          watch_party_id: command.watch_party_id,
          participant_id: command.participant_id,
          song_id: command.song_id,
          shortlisted: !Enum.any?(participant.shortlisted, &(&1 == command.song_id))
        },
        %Events.SongNopedChanged{
          watch_party_id: command.watch_party_id,
          participant_id: command.participant_id,
          song_id: command.song_id,
          noped: false
        }
      ]
    else
      nil -> {:error, :unknown_participant}
    end
  end

  def execute(%__MODULE__{} = watch_party, %Commands.ToggleSongNoped{} = command) do
    with %{} = participant <- participant(watch_party, command.participant_id) do
      [
        %Events.SongNopedChanged{
          watch_party_id: command.watch_party_id,
          participant_id: command.participant_id,
          song_id: command.song_id,
          noped: !Enum.any?(participant.noped, &(&1 == command.song_id))
        },
        %Events.SongShortlistedChanged{
          watch_party_id: command.watch_party_id,
          participant_id: command.participant_id,
          song_id: command.song_id,
          shortlisted: false
        }
      ]
    else
      nil -> {:error, :unknown_participant}
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
        participants: Enum.into([new_participant(event.owner_id)], %{})
    }
  end

  def apply(%__MODULE__{} = watch_party, %Events.SongShortlistedChanged{} = event) do
    participant = participant(watch_party, event.participant_id)

    %__MODULE__{
      watch_party
      | participants:
          Map.replace(watch_party.participants, event.participant_id, %{
            participant
            | shortlisted: toggle_song(participant.shortlisted, event.song_id, event.shortlisted)
          })
    }
  end

  def apply(%__MODULE__{} = watch_party, %Events.SongNopedChanged{} = event) do
    participant = participant(watch_party, event.participant_id)

    %__MODULE__{
      watch_party
      | participants:
          Map.replace(watch_party.participants, event.participant_id, %{
            participant
            | noped: toggle_song(participant.noped, event.song_id, event.noped)
          })
    }
  end

  defp new_participant(id) do
    {id, %{shortlisted: [], noped: [], votes: %{}}}
  end

  defp participant(state, id) do
    Map.get(state.participants, id)
  end

  defp toggle_song(list, song_id, true) do
    list
    |> MapSet.new()
    |> MapSet.put(song_id)
    |> MapSet.to_list()
  end

  defp toggle_song(list, song_id, false) do
    Enum.reject(list, &(&1 == song_id))
  end
end
