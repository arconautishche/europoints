defmodule Pointex.Model.Aggregates.WatchParty do
  defstruct [:id, :name, :owner_id, :year, :show, :participants]

  alias Pointex.Model.Commands
  alias Pointex.Model.Events

  def execute(%__MODULE__{} = watch_party, %Commands.FinalizeParticipantsVote{} = command) do
    with %{} = participant <- participant(watch_party, command.participant_id) do
      participants_top_ten = participant.top_ten

      if complete_top_ten?(participants_top_ten) do
        totals =
          watch_party.participants
          |> Enum.filter(fn {id, participant} ->
            participant.votes_final? || id == command.participant_id
          end)
          |> Enum.map(fn {_id, participant} -> participant.top_ten end)
          |> Enum.flat_map(fn top_ten -> top_ten end)
          |> Enum.group_by(fn {_p, s} -> s end)
          |> Enum.map(fn {s, song_points} ->
            {s, Enum.reduce(song_points, 0, fn {p, _}, acc -> p + acc end)}
          end)
          |> Enum.into(%{})

        [
          %Events.TopTenByParticipantUpdated{
            watch_party_id: watch_party.id,
            participant_id: command.participant_id,
            final?: true,
            top_ten: participant.top_ten
          },
          %Events.WatchPartyTotalsUpdated{
            watch_party_id: command.watch_party_id,
            totals: totals
          }
        ]
      else
        {:error, :vote_incomplete}
      end
    else
      nil -> {:error, :unknown_participant}
    end
  end

  def execute(_, %Commands.PostRealResults{} = command) do
    [%Events.RealResultsPosted{watch_party_id: command.watch_party_id, points: command.points}]
  end

  # state mutators

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
            | top_ten: event.top_ten,
              votes_final?: event.final?
          })
    }
  end

  def apply(%__MODULE__{} = watch_party, %Events.WatchPartyTotalsUpdated{}) do
    watch_party
  end

  def apply(%__MODULE__{} = watch_party, %Events.RealResultsPosted{}) do
    watch_party
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

  defp complete_top_ten?(top_ten) do
    Enum.all?(top_ten, fn {_p, s} -> s != nil end)
  end
end
