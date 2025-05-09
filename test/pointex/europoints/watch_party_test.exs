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

  describe "start" do
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

  describe "join" do
    setup context do
      Map.merge(context, %{
        participant_1: Account.register!("Fan 1"),
        participant_2: Account.register!("Fan 2")
      })
    end

    test "can add multiple participants WatchParty", %{
      season: season,
      owner_account: owner_account,
      participant_1: participant_1,
      participant_2: participant_2
    } do
      show = Enum.find(season.shows, &(&1.kind == :final))
      watch_party = WatchParty.start!("Test WP", owner_account.id, show.id)

      {:ok, watch_party} = WatchParty.join(watch_party, participant_1.id)

      {:ok, %WatchParty{participants: participants}} =
        WatchParty.join(watch_party, participant_2.id)

      assert length(participants) == 3
    end

    test "cannot join multiple times with the same account", %{
      season: season,
      owner_account: owner_account,
      participant_1: participant_1
    } do
      show = Enum.find(season.shows, &(&1.kind == :final))
      watch_party = WatchParty.start!("Test WP", owner_account.id, show.id)

      {:ok, watch_party} = WatchParty.join(watch_party, participant_1.id)
      assert {:error, _} = WatchParty.join(watch_party, participant_1.id)
    end
  end

  describe "leave" do
    setup context do
      Map.merge(context, %{
        participant_1: Account.register!("Fan 1"),
        participant_2: Account.register!("Fan 2")
      })
    end

    test "cannot leave a watch party", %{
      season: season,
      owner_account: owner_account,
      participant_1: account_1,
      participant_2: account_2
    } do
      show = Enum.find(season.shows, &(&1.kind == :final))
      watch_party = WatchParty.start!("Test WP", owner_account.id, show.id)

      {:ok, watch_party} = WatchParty.join(watch_party, account_1.id)
      {:ok, watch_party} = WatchParty.join(watch_party, account_2.id)

      leaver_id = Enum.find_value(watch_party.participants, &if(&1.account_id == account_2.id, do: &1.id))

      assert {:ok, %{participants: participants}} = WatchParty.leave(watch_party, leaver_id)

      owner_id = owner_account.id
      remaining_participant_id = account_1.id

      assert [
               %{account_id: ^owner_id},
               %{account_id: ^remaining_participant_id}
             ] = participants
    end
  end
end
