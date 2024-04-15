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
  end
end
