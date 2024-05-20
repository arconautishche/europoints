defmodule Pointex.Europoints.WatchParty.TotalPointsCalculation do
  use Ash.Resource.Calculation

  @impl true
  def load(_query, _opts, _context) do
    [show: :songs, participants: :top_10_with_points]
  end

  @impl true
  def calculate(watch_parties, _opts, _context) do
    Enum.map(
      watch_parties,
      fn watch_party ->
        Enum.map(
          watch_party.show.songs,
          &%{
            song: &1,
            points: total_points_for_song(&1, watch_party.participants)
          }
        )
      end
    )
  end

  defp total_points_for_song(song, participants) do
    participants
    |> Enum.filter(& &1.final_vote_submitted)
    |> Enum.reduce(0, fn participant, total_points ->
      total_points +
        Enum.find_value(
          participant.top_10_with_points,
          0,
          fn {points, country} -> if country == song.country, do: points end
        )
    end)
  end
end
