defmodule Pointex.Model.Aggregates.WatchParty do
  defstruct [:id, :name, :owner_id, :year, :show, :participants]

  alias Pointex.Model.PossiblePoints
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

  def execute(%__MODULE__{} = watch_party, %Commands.GivePointsToSong{} = command) do
    with %{} = participant <- participant(watch_party, command.participant_id) do
      [
        %Events.TopTenByParticipantUpdated{
          watch_party_id: command.watch_party_id,
          participant_id: command.participant_id,
          top_ten: insert_vote(participant.top_ten, command.points, command.song_id)
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

  def apply(%__MODULE__{} = watch_party, %Events.TopTenByParticipantUpdated{} = event) do
    participant = participant(watch_party, event.participant_id)

    %__MODULE__{
      watch_party
      | participants:
          Map.replace(watch_party.participants, event.participant_id, %{
            participant
            | top_ten: event.top_ten
          })
    }
  end

  defp new_participant(id) do
    {id,
     %{
       shortlisted: [],
       noped: [],
       top_ten: PossiblePoints.asc() |> Enum.map(&{&1, nil}) |> Enum.into(%{})
     }}
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

  defp insert_vote(top_ten, points, song_id) do
    top_ten =
      case Enum.find(top_ten, fn {_, song} -> song == song_id end) do
        nil -> top_ten
        {prev_points, _} -> Map.replace(top_ten, prev_points, nil)
      end

    case Map.get(top_ten, points) do
      nil ->
        Map.replace(top_ten, points, song_id)

      _points_already_taken ->
        top_ten = Enum.reverse(top_ten)
        song_index = Enum.find_index(top_ten, fn {p, _s} -> p == points end)

        {songs_above, songs_with} = Enum.split(top_ten, song_index)
        stop_index = Enum.find_index(songs_with, fn {_p, s} -> s == nil end) || 9

        songs_with
        |> Enum.with_index()
        |> Enum.map(fn {{p, s}, idx} ->
          if p > points || idx >= stop_index do
            {p, s}
          else
            {PossiblePoints.dec(p), s}
          end
        end)
        |> Enum.reject(fn {p, _} -> p < 1 end)
        |> Enum.concat([{points, song_id}])
        |> Enum.concat(songs_above)
        |> Enum.sort()
        |> Enum.into(%{})
    end
  end
end
