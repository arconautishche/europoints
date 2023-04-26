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
      |> WatchParty.apply(%Events.WatchPartyStarted{
        id: wp_id,
        name: "test party",
        owner_id: owner_id,
        year: 2023,
        show: :final
      })
      |> WatchParty.apply(%Events.ParticipantJoinedWatchParty{
        id: wp_id,
        participant_id: participant_1_id,
        name: "test party",
        owner_id: owner_id,
        year: 2023,
        show: :final
      })
      |> WatchParty.apply(%Events.ParticipantJoinedWatchParty{
        id: wp_id,
        participant_id: participant_2_id,
        name: "test party",
        owner_id: owner_id,
        year: 2023,
        show: :final
      })

    {:ok,
     started_wp: initial_state,
     owner_id: owner_id,
     wp_id: wp_id,
     participant_1_id: participant_1_id,
     participant_2_id: participant_2_id}
  end

  describe "execute GivePointsToSong, top 10 by participant events" do
    test "first vote", %{started_wp: state, owner_id: owner_id, wp_id: wp_id} do
      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => nil,
                   2 => nil,
                   3 => nil,
                   4 => nil,
                   5 => nil,
                   6 => nil,
                   7 => nil,
                   8 => nil,
                   10 => nil,
                   12 => "Finland"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "Finland",
                 points: 12
               })
    end

    test "second vote", %{started_wp: state, owner_id: owner_id, wp_id: wp_id} do
      [first_event] =
        WatchParty.execute(state, %Commands.GivePointsToSong{
          watch_party_id: wp_id,
          participant_id: owner_id,
          song_id: "Finland",
          points: 12
        })

      state = WatchParty.apply(state, first_event)

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => nil,
                   2 => nil,
                   3 => nil,
                   4 => nil,
                   5 => nil,
                   6 => nil,
                   7 => "France",
                   8 => nil,
                   10 => nil,
                   12 => "Finland"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "France",
                 points: 7
               })
    end

    test "vote replaces points", %{started_wp: state, owner_id: owner_id, wp_id: wp_id} do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
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

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => "Song 2",
                   2 => "Song 3",
                   3 => "Song 4",
                   4 => "Song 5",
                   5 => "Song 6",
                   6 => "Song 7",
                   7 => "Song 8",
                   8 => "Song 10",
                   10 => "New Song 10",
                   12 => "Song 12"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "New Song 10",
                 points: 10
               })
    end

    test "vote replaces points, but gap underneath", %{
      started_wp: state,
      owner_id: owner_id,
      wp_id: wp_id
    } do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
          top_ten: %{
            1 => "Song 1",
            2 => "Song 2",
            3 => "Song 3",
            4 => "Song 4",
            5 => nil,
            6 => "Song 6",
            7 => "Song 7",
            8 => "Song 8",
            10 => "Song 10",
            12 => "Song 12"
          }
        })

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => "Song 1",
                   2 => "Song 2",
                   3 => "Song 3",
                   4 => "Song 4",
                   5 => "Song 6",
                   6 => "Song 7",
                   7 => "Song 8",
                   8 => "Song 10",
                   10 => "New Song 10",
                   12 => "Song 12"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "New Song 10",
                 points: 10
               })
    end

    test "vote replaces points, but gap above and underneath", %{
      started_wp: state,
      owner_id: owner_id,
      wp_id: wp_id
    } do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
          top_ten: %{
            1 => "Song 1",
            2 => "Song 2",
            3 => "Song 3",
            4 => nil,
            5 => nil,
            6 => "Song 6",
            7 => "Song 7",
            8 => nil,
            10 => "Song 10",
            12 => "Song 12"
          }
        })

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => "Song 1",
                   2 => "Song 2",
                   3 => "Song 3",
                   4 => nil,
                   5 => "Song 6",
                   6 => "Song 7",
                   7 => "New Song 7",
                   8 => nil,
                   10 => "Song 10",
                   12 => "Song 12"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "New Song 7",
                 points: 7
               })
    end

    test "vote replaces points, and fills a gap underneath", %{
      started_wp: state,
      owner_id: owner_id,
      wp_id: wp_id
    } do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
          top_ten: %{
            1 => "Song 1",
            2 => "Song 2",
            3 => "Song 3",
            4 => nil,
            5 => nil,
            6 => "Song 6",
            7 => "Song 7",
            8 => nil,
            10 => "Song 10",
            12 => "Song 12"
          }
        })

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => "Song 1",
                   2 => "Song 2",
                   3 => "Song 3",
                   4 => nil,
                   5 => nil,
                   6 => "Song 6",
                   7 => "Song 7",
                   8 => "Song 10",
                   10 => "New Song 10",
                   12 => "Song 12"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "New Song 10",
                 points: 10
               })
    end

    test "all places taken, bump an existing song", %{
      started_wp: state,
      owner_id: owner_id,
      wp_id: wp_id
    } do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
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

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => "Song 1",
                   2 => "Song 2",
                   3 => "Song 3",
                   4 => "Song 4",
                   5 => "Song 5",
                   6 => "Song 6",
                   7 => "Song 7",
                   8 => "Song 8",
                   10 => "Song 12",
                   12 => "Song 10"
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "Song 10",
                 points: 12
               })
    end

    test "unvote", %{started_wp: state, owner_id: owner_id, wp_id: wp_id} do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
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

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => nil,
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
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "Song 1",
                 points: nil
               })
    end

    test "remove last vote", %{started_wp: state, owner_id: owner_id, wp_id: wp_id} do
      state =
        WatchParty.apply(state, %Events.TopTenByParticipantUpdated{
          watch_party_id: wp_id,
          participant_id: owner_id,
          top_ten: %{
            1 => "Last Song",
            2 => nil,
            3 => nil,
            4 => nil,
            5 => nil,
            6 => nil,
            7 => nil,
            8 => nil,
            10 => nil,
            12 => nil
          }
        })

      assert [
               %Events.TopTenByParticipantUpdated{
                 top_ten: %{
                   1 => nil,
                   2 => nil,
                   3 => nil,
                   4 => nil,
                   5 => nil,
                   6 => nil,
                   7 => nil,
                   8 => nil,
                   10 => nil,
                   12 => nil
                 }
               }
             ] =
               WatchParty.execute(state, %Commands.GivePointsToSong{
                 watch_party_id: wp_id,
                 participant_id: owner_id,
                 song_id: "Last Song",
                 points: nil
               })
    end
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
          final?: true,
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
