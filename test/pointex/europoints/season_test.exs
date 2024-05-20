defmodule Pointex.Europoints.SeasonTest do
  use Pointex.DataCase
  alias Pointex.Europoints.Season

  test "new season creates three shows automatically: SF1, SF2, Final" do
    Season.new!(2024)

    assert %{
             shows: [
               %{kind: :final},
               %{kind: :semi_final_1},
               %{kind: :semi_final_2}
             ]
           } =
             Ash.get!(Season, 2024, load: :shows)
  end
end
