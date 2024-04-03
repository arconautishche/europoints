defmodule Pointex.Europoints.WatchPartyTest do
  use Pointex.DataCase
  alias Pointex.Europoints.Account
  alias Pointex.Europoints.Season
  alias Pointex.Europoints.WatchParty

  setup do
    season = Season.new!(2024)
    owner_account = Account.register!("Euro Papa")

    %{
      season: season,
      owner_account: owner_account
    }
  end

  test "the correct show is linked to new WatchParty", %{
    season: season,
    owner_account: owner_account
  } do
    %{id: show_id} = Enum.find(season.shows, &(&1.kind == :semi_final_2))

    assert {:ok, %{show: %{id: ^show_id}}} =
             WatchParty.start("Test WP", owner_account.id, show_id)
  end

  test "the owner is added to the participants", %{
    season: season,
    owner_account: %{id: owner_account_id}
  } do
    show = Enum.find(season.shows, &(&1.kind == :semi_final_2))

    assert {:ok, %{participants: [%{account_id: ^owner_account_id, owner: true}]}} =
             WatchParty.start("Test WP", owner_account_id, show.id)
  end
end
