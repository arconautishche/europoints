defmodule Pointex.Europoints.Participant.Top10WithPoints do
  use Ash.Resource.Calculation
  alias Pointex.Europoints.Participant
  alias Pointex.Europoints.Participant.Voting

  @points Voting.all_points()

  @impl true
  def calculate(participants, _opts, _context) do
    Enum.map(participants, &add_points_to_top_10/1)
  end

  defp add_points_to_top_10(%Participant{top_10: top_10_as_list}) do
    @points
    |> Enum.zip(top_10_as_list)
    |> Map.new()
  end
end
