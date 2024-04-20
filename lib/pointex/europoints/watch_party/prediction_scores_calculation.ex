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

  def semi_final_prediction_scores(%WatchParty{} = wp) do
    countries_in_final = wp.show.songs |> Enum.filter(& &1.went_to_final) |> Enum.map(& &1.country) |> MapSet.new()

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
  end

  def final_prediction_scores(%WatchParty{} = _wp) do
    %{}
  end
end
