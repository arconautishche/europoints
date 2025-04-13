defmodule Pointex.Europoints.Participant.CanSubmitFinalVote do
  alias Pointex.Europoints.Participant
  use Ash.Resource.Calculation

  @impl true
  def load(_query, _opts, _context) do
    [:unused_points]
  end

  @impl true
  def calculate(participants, _opts, _context) do
    Enum.map(
      participants,
      &(&1.final_vote_submitted == false && all_votes_given?(&1))
    )
  end

  defp all_votes_given?(%Participant{top_10: top_10}) do
    Enum.all?(top_10, &(&1 != nil))
  end
end
