defmodule Pointex.Europoints.ParticipantTest do
  use Pointex.DataCase, async: true
  import Pointex.Test.SeasonFixtures
  alias Pointex.Europoints
  alias Pointex.Europoints.Song
  alias Pointex.Europoints.WatchParty
  alias Pointex.Europoints.Participant

  setup do
    season = Europoints.Season.new!(2024)
    owner_account = Europoints.Account.register!("Euro Papa")
    show = Enum.find(season.shows, &(&1.kind == :semi_final_1))

    %{season: season.year, country: "Ukraine", artist: "Who Knows", name: "Trololo", img: "ua.png"}
    |> Song.register!()
    |> Ash.Changeset.for_update(:update, %{order_in_sf1: 1})
    |> Ash.update!()

    %{season: season.year, country: "Belgium", artist: "Wie Weet", name: "Tralala", img: "be.png"}
    |> Song.register!()
    |> Ash.Changeset.for_update(:update, %{order_in_sf1: 2})
    |> Ash.update!()

    %{participants: [participant]} = WatchParty.start!("Test WP", owner_account.id, show.id)

    %{
      season: season,
      participant: Ash.get!(Participant, participant.id)
    }
  end

  test "default values", %{participant: participant} do
    assert participant.shortlist == []
    assert participant.noped == []
    assert participant.top_10 == 0..9 |> Enum.map(fn _ -> nil end)

    assert participant.top_10_with_points == %{
             12 => nil,
             10 => nil,
             8 => nil,
             7 => nil,
             6 => nil,
             5 => nil,
             4 => nil,
             3 => nil,
             2 => nil,
             1 => nil
           }

    participant = Ash.load!(participant, [:used_points, :unused_points])
    assert participant.used_points == []
    assert participant.unused_points == [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
  end

  describe "toggle_shortlisted" do
    test "first shortlist", %{participant: participant} do
      assert {:ok, %{shortlist: ["Ukraine"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end

    test "seconds shortlist", %{participant: participant} do
      participant = Participant.toggle_shortlisted!(participant, "Belgium")
      assert {:ok, %{shortlist: ["Belgium", "Ukraine"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end

    test "removes from the 'noped' when shortlisting", %{participant: participant} do
      participant =
        participant
        |> Participant.toggle_noped!("Belgium")
        |> Participant.toggle_noped!("Ukraine")

      assert {:ok, %{shortlist: ["Ukraine"], noped: ["Belgium"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end
  end

  describe "toggle_noped" do
    test "first nope", %{participant: participant} do
      assert {:ok, %{noped: ["Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end

    test "seconds nope", %{participant: participant} do
      participant = Participant.toggle_noped!(participant, "Belgium")
      assert {:ok, %{noped: ["Belgium", "Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end

    test "removes from the 'shortlist' when noped", %{participant: participant} do
      participant =
        participant
        |> Participant.toggle_shortlisted!("Belgium")
        |> Participant.toggle_shortlisted!("Ukraine")

      assert {:ok, %{shortlist: ["Belgium"], noped: ["Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end
  end

  describe "give_points" do
    test "first vote", %{participant: participant} do
      assert {:ok, participant} = Participant.give_points(participant, "Some country", 5)
      assert %{5 => "Some country", 4 => nil, 6 => nil} = participant.top_10_with_points
    end

    test "not the first vote, from unused points", %{participant: participant} do
      participant = Participant.give_points!(participant, "FivePointer", 5)

      assert {:ok,
              %{
                top_10_with_points: %{
                  5 => "FivePointer",
                  12 => "TheWinner"
                }
              }} =
               Participant.give_points(participant, "TheWinner", 12)
    end

    test "giving 12 points, when 12 is used, but 10 is not", %{participant: participant} do
      participant = Participant.give_points!(participant, "FirstWinner", 12)

      assert {:ok,
              %{
                top_10_with_points: %{
                  12 => "ActualWinner",
                  10 => "FirstWinner"
                }
              }} =
               Participant.give_points(participant, "ActualWinner", 12)
    end

    test "giving 8 points, when 7 & 8 are already used", %{participant: participant} do
      participant = Participant.give_points!(participant, "Original7", 7)
      participant = Participant.give_points!(participant, "Original8", 8)

      assert {:ok,
              %{
                top_10_with_points: %{
                  8 => "Current8",
                  7 => "Original8",
                  6 => "Original7"
                }
              }} =
               Participant.give_points(participant, "Current8", 8)
    end

    test "giving 2 points, when 1 & 2 are already used", %{participant: participant} do
      participant = Participant.give_points!(participant, "Original1", 1)
      participant = Participant.give_points!(participant, "Original2", 2)

      assert {:ok,
              %{
                top_10_with_points: %{
                  2 => "Current2",
                  1 => "Original2"
                }
              }} =
               Participant.give_points(participant, "Current2", 2)
    end

    test "bumping a song up", %{participant: participant} do
      participant =
        participant
        |> Participant.give_points!("Original2", 2)
        |> Participant.give_points!("Original2", 3)

      assert participant.top_10 == [nil, nil, nil, nil, nil, nil, nil, "Original2", nil, nil]

      assert participant.top_10_with_points == %{
               12 => nil,
               10 => nil,
               8 => nil,
               7 => nil,
               6 => nil,
               5 => nil,
               4 => nil,
               3 => "Original2",
               2 => nil,
               1 => nil
             }

      assert participant.used_points == [3]
      assert participant.unused_points == [12, 10, 8, 7, 6, 5, 4, 2, 1]
    end

    test "can remove a song from top_10", %{participant: participant} do
      participant = Participant.give_points!(participant, "Original1", 1)

      assert {:ok,
              %{
                top_10_with_points: %{
                  1 => nil
                }
              }} =
               Participant.give_points(participant, "Original1", nil)
    end

    test "does not shift songs down if there's space in between", %{participant: participant} do
      participant = Participant.give_points!(participant, "Original2", 2)
      participant = Participant.give_points!(participant, "Original8", 8)

      assert {:ok,
              %{
                top_10_with_points: %{
                  8 => "Current8",
                  7 => "Original8",
                  2 => "Original2"
                }
              }} =
               Participant.give_points(participant, "Current8", 8)
    end

    test "cannot give points after submission", %{participant: participant} do
      participant =
        participant
        |> Ash.Changeset.for_update(:update, %{final_vote_submitted: true})
        |> Ash.update!()

      assert {:error, %{errors: [%{field: :final_vote_submitted}]}} = Participant.give_points(participant, "TheWinner", 12)
    end

    test "validates 'points' to be valid", %{participant: participant} do
      assert {:error, %{errors: [%{field: :points}]}} = Participant.give_points(participant, "TheWinner", 11)
    end

    @tag :skip
    test "validates 'country' to be from the WatchParty's show"
  end

  describe "finalize_top_10" do
    test "cannot submit final vote if not all points have been used", %{participant: participant} do
      {:error, %{errors: [%{field: :can_submit_final_vote}]}} = Participant.finalize_top_10(participant)
    end

    test "can submit final vote if all points have been used", %{season: season, participant: participant} do
      generate_songs(season.year)

      participant =
        participant
        |> Participant.give_points!("Ukraine", 12)
        |> Participant.give_points!("Belgium", 10)
        |> Participant.give_points!("United Kingdom", 8)
        |> Participant.give_points!("Sweden", 7)
        |> Participant.give_points!("Netherlands", 6)
        |> Participant.give_points!("Albania", 5)
        |> Participant.give_points!("Italy", 4)
        |> Participant.give_points!("France", 3)
        |> Participant.give_points!("Germany", 2)
        |> Participant.give_points!("Spain", 1)
        |> Participant.finalize_top_10!()

      assert participant.final_vote_submitted
    end
  end
end
