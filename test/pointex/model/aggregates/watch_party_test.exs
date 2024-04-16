defmodule Pointex.Model.Aggregates.WatchPartyTest do
  use ExUnit.Case
  alias Pointex.Model.Commands
  alias Pointex.Model.Events
  alias Pointex.Model.Aggregates.WatchParty

  setup do
    owner_id = Ecto.UUID.generate()
    participant_1_id = Ecto.UUID.generate()
    participant_2_id = Ecto.UUID.generate()
    wp_id = Ecto.UUID.generate()

    initial_state =
      %WatchParty{}

    {:ok, started_wp: initial_state, owner_id: owner_id, wp_id: wp_id, participant_1_id: participant_1_id, participant_2_id: participant_2_id}
  end

  describe "execute FinalizeParticipantsVote, top 10" do
    test "points are summed up", %{
      started_wp: state,
      owner_id: owner_id,
      wp_id: wp_id,
      participant_1_id: participant_1_id,
      participant_2_id: participant_2_id
    } do
      state =
        state
        |> WatchParty.apply(%Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
          final?: true,
          top_ten: %{
            1 => "Song 1",
            2 => "Song 2",
            3 => "Song 3",
            4 => "Song 4",
            5 => "Song 5",
            6 => "Song 6",
            7 => "Song 13",
            8 => "Song 8",
            10 => "Song 10",
            12 => "Song 12"
          }
        })
        |> WatchParty.apply(%Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: participant_1_id,
          final?: false,
          top_ten: %{
            1 => "Song 1",
            2 => "Song 2",
            3 => "Song 3",
            4 => "Song 4",
            5 => "Song 5",
            6 => "Song 6",
            7 => "Song 7",
            8 => "Song 8",
            10 => "Song 10",
            12 => "Song 12"
          }
        })
        |> WatchParty.apply(%Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: participant_2_id,
          final?: false,
          top_ten: %{
            1 => "Song 12",
            2 => "Song 1",
            3 => "Song 2",
            4 => "Song 3",
            5 => "Song 4",
            6 => "Song 5",
            7 => "Song 6",
            8 => "Song 7",
            10 => "Song 8",
            12 => "Song 10"
          }
        })

      [individual_top_ten | [total_score]] =
        WatchParty.execute(state, %Commands.FinalizeParticipantsVote{
          watch_party_id: wp_id,
          participant_id: participant_2_id
        })

      assert individual_top_ten.final?

      assert total_score == %Events.WatchPartyTotalsUpdated{
               watch_party_id: wp_id,
               totals: %{
                 "Song 1" => 3,
                 "Song 2" => 5,
                 "Song 3" => 7,
                 "Song 4" => 9,
                 "Song 5" => 11,
                 "Song 6" => 13,
                 "Song 7" => 8,
                 "Song 8" => 18,
                 "Song 10" => 22,
                 "Song 12" => 13,
                 "Song 13" => 7
               }
             }
    end
  end
end
