defmodule Pointex.Europoints.WatchParty.PredictionScoresCalculation do
  use Ash.Calculation
  alias Pointex.Europoints.WatchParty

  @impl true
  def load(_query, _opts, _context) do
    [show: :songs, participants: [:top_10, :top_10_with_points]]
  end

  @impl true
  def calculate(watch_parties, _opts, _context) do
    Enum.map(
      watch_parties,
      fn watch_party ->
        case watch_party.show.kind do
          :semi_final_1 -> semi_final_prediction_scores(watch_party)
          :semi_final_2 -> semi_final_prediction_scores(watch_party)
          :final -> final_prediction_scores(watch_party)
        end
      end
    )
  end

  @points_for_sf_prefiction 1

  defp semi_final_prediction_scores(%WatchParty{} = wp) do
    countries_in_final = wp.show.songs |> Enum.filter(& &1.went_to_final) |> Enum.map(& &1.country) |> MapSet.new()

    if Enum.count(countries_in_final) > 0 do
      wp.participants
      |> Enum.filter(& &1.final_vote_submitted)
      |> Enum.map(fn participant ->
        {participant,
         participant.top_10
         |> MapSet.new()
         |> MapSet.intersection(countries_in_final)
         |> Enum.count()
         |> Kernel.*(@points_for_sf_prefiction)}
      end)
      |> Map.new()
    else
      %{error: "Actual results incomplete or incorrect"}
    end
  end

  @points_for_correct_winner 10
  @points_for_correct_placing 3
  @points_for_placing_1_removed 2
  @points_for_placing_2_removed 1

  defp final_prediction_scores(%WatchParty{} = wp) do
    actual_top_10 =
      wp.show.songs
      |> Enum.filter(&(&1.actual_place_in_final != nil))
      |> Enum.sort_by(& &1.actual_place_in_final, :asc)
      |> Enum.map(&{&1.country, &1.actual_place_in_final})
      |> Map.new()

    if Enum.count(actual_top_10) == 10 do
      wp.participants
      |> Enum.filter(& &1.final_vote_submitted)
      |> Enum.map(fn participant ->
        {participant, participant_prediction_for_final(participant.top_10, actual_top_10)}
      end)
      |> Map.new()
    else
      %{error: "Actual results incomplete or incorrect"}
    end
  end

  defp participant_prediction_for_final(top_10, actual_top_10) do
    top_10
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {country, place}, total_score ->
      total_score + points_for_place(place, Map.get(actual_top_10, country, :not_in_top_10))
    end)
  end

  defp points_for_place(_, :not_in_top_10), do: 0
  defp points_for_place(1, 1), do: @points_for_correct_winner

  defp points_for_place(participant, actual) do
    case abs(participant - actual) do
      0 -> @points_for_correct_placing
      1 -> @points_for_placing_1_removed
      2 -> @points_for_placing_2_removed
      _ -> 0
    end
  end
end
