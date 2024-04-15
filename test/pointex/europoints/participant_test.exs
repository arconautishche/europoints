defmodule Pointex.Europoints.ParticipantTest do
  use Pointex.DataCase, async: true
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
    |> Europoints.update!()

    %{season: season.year, country: "Belgium", artist: "Wie Weet", name: "Tralala", img: "be.png"}
    |> Song.register!()
    |> Ash.Changeset.for_update(:update, %{order_in_sf1: 2})
    |> Europoints.update!()

    %{participants: [participant]} = WatchParty.start!("Test WP", owner_account.id, show.id)

    %{
      season: season,
      particpant: participant
    }
  end

  test "default values", %{particpant: participant} do
    assert participant.shortlist == []
  end

  describe "toggle_shortlisted" do
    test "first shortlist", %{particpant: participant} do
      assert {:ok, %{shortlist: ["Ukraine"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end

    test "seconds shortlist", %{particpant: participant} do
      participant = Participant.toggle_shortlisted!(participant, "Belgium")
      assert {:ok, %{shortlist: ["Belgium", "Ukraine"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end

    test "removes from the 'noped' when shortlisting", %{particpant: participant} do
      participant =
        participant
        |> Participant.toggle_noped!("Belgium")
        |> Participant.toggle_noped!("Ukraine")

      assert {:ok, %{shortlist: ["Ukraine"], noped: ["Belgium"]}} = Participant.toggle_shortlisted(participant, "Ukraine")
    end
  end

  describe "toggle_noped" do
    test "first nope", %{particpant: participant} do
      assert {:ok, %{noped: ["Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end

    test "seconds nope", %{particpant: participant} do
      participant = Participant.toggle_noped!(participant, "Belgium")
      assert {:ok, %{noped: ["Belgium", "Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end

    test "removes from the 'shortlist' when noped", %{particpant: participant} do
      participant =
        participant
        |> Participant.toggle_shortlisted!("Belgium")
        |> Participant.toggle_shortlisted!("Ukraine")

      assert {:ok, %{shortlist: ["Belgium"], noped: ["Ukraine"]}} = Participant.toggle_noped(participant, "Ukraine")
    end
  end
end
