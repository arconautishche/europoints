defmodule Pointex.Model.Aggregates.WatchPartyTest do
  use ExUnit.Case
  alias Pointex.Model.Commands
  alias Pointex.Model.Events
  alias Pointex.Model.Aggregates.WatchParty

  setup do
    owner_id = Ecto.UUID.generate()
    wp_id = Ecto.UUID.generate()

    initial_state =
      WatchParty.apply(%WatchParty{}, %Events.WatchPartyStarted{
        id: wp_id,
        name: "test party",
        owner_id: owner_id,
        year: 2023,
        show: :final
      })

    {:ok, started_wp: initial_state, owner_id: owner_id, wp_id: wp_id}
  end

  describe "execute GivePointsToSong" do
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
  end
end
