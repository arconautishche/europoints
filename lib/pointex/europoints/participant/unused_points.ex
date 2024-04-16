defmodule Pointex.Europoints.Participant.UnusedPoints do
  use Ash.Calculation
  alias Pointex.Europoints.Participant.Voting

  @impl true
  def load(_query, _opts, _context) do
    [:top_10_with_points]
  end

  @impl true
  def calculate(participants, _opts, _context) do
    Enum.map(
      participants,
      &Voting.points(&1.top_10_with_points, fn {_points, song} -> song == nil end)
    )
  end
end
