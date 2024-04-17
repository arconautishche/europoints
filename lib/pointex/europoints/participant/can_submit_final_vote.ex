defmodule Pointex.Europoints.Participant.CanSubmitFinalVote do
  use Ash.Calculation

  @impl true
  def load(_query, _opts, _context) do
    [:unused_points]
  end

  @impl true
  def calculate(participants, _opts, _context) do
    Enum.map(
      participants,
      &(&1.final_vote_submitted == false && &1.unused_points == [])
    )
  end
end
