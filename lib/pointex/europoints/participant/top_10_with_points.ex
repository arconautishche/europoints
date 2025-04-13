defmodule Pointex.Europoints.Participant.Top10WithPoints do
  use Ash.Resource.Calculation
  alias Pointex.Europoints.Participant.Voting

  @impl true
  def calculate(participants, _opts, _context) do
    Enum.map(participants, &Voting.map_points_to_top_10(&1.top_10))
  end
end
