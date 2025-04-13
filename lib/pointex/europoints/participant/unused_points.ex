defmodule Pointex.Europoints.Participant.UnusedPoints do
  use Ash.Resource.Calculation
  alias Pointex.Europoints.Participant.Voting

  @impl true
  def load(_query, _opts, _context) do
    [:top_10_with_points]
  end

  @impl true
  def calculate(participants, _opts, _context) do
    participants
    |> Enum.map(&Voting.map_points_to_top_10(&1.top_10))
    |> Enum.map(&Voting.points(&1, fn {_points, song} -> song == nil end))
  end
end
