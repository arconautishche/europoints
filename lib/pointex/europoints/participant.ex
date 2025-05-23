defmodule Pointex.Europoints.Participant do
  use Ash.Resource,
    domain: Pointex.Europoints,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource],
    notifiers: [Ash.Notifier.PubSub],
    primary_read_warning?: false

  import Ash.Changeset, only: [get_argument: 2, get_attribute: 2, change_attribute: 3]
  alias Pointex.Europoints
  alias Pointex.Europoints.Participant
  alias Pointex.Europoints.Participant.Voting

  resource do
    description """
    A participant in a `WatchParty`. A user can have multiple `Participant` records - one for each `WatchParty` they've joined.
    """
  end

  attributes do
    uuid_primary_key :id

    attribute :owner, :boolean do
      allow_nil? false
      default false
    end

    attribute :shortlist, {:array, :string}, default: []
    attribute :noped, {:array, :string}, default: []

    attribute :top_10, {:array, :string} do
      constraints nil_items?: true,
                  min_length: 10,
                  max_length: 10

      default 0..9 |> Enum.map(fn _ -> nil end)
    end

    attribute :final_vote_submitted, :boolean do
      public? true
      allow_nil? false
      default false
    end
  end

  relationships do
    belongs_to :account, Europoints.Account do
      allow_nil? false
    end

    belongs_to :watch_party, Europoints.WatchParty do
      attribute_writable? true
      allow_nil? false
    end
  end

  calculations do
    calculate :top_10_with_points, :map, Participant.Top10WithPoints
    calculate :used_points, {:array, :integer}, Participant.UsedPoints
    calculate :unused_points, {:array, :integer}, Participant.UnusedPoints
    calculate :can_submit_final_vote, :boolean, Participant.CanSubmitFinalVote
  end

  identities do
    identity :one_participant_per_account_per_wp, [:account_id, :watch_party_id]
  end

  actions do
    defaults [:destroy, update: :*]

    create :new do
      primary? true

      argument :account_id, :uuid do
        allow_nil? false
      end

      accept [:owner, :watch_party_id]

      change manage_relationship(:account_id, :account,
               type: :append_and_remove,
               value_is_key: :id,
               on_lookup: :relate
             )
    end

    read :read do
      primary? true
      prepare build(load: [:watch_party, :account])
    end

    read :for_account do
      argument :account_id, :uuid do
        allow_nil? false
      end

      prepare build(load: [:watch_party, :account])

      prepare fn query, _ ->
        require Ash.Query
        account_id = Ash.Query.get_argument(query, :account_id)
        Ash.Query.filter(query, account.id == account_id)
      end
    end

    update :toggle_shortlisted do
      require_atomic? false

      argument :country, :string do
        allow_nil? false
      end

      change fn changeset, _ ->
        changeset
        |> toggle_country_in_list(:shortlist)
        |> remove_country_from_list(:noped)
      end
    end

    update :toggle_noped do
      require_atomic? false

      argument :country, :string do
        allow_nil? false
      end

      change fn changeset, _ ->
        changeset
        |> toggle_country_in_list(:noped)
        |> remove_country_from_list(:shortlist)
      end
    end

    update :give_points do
      require_atomic? false

      argument :points, :integer do
        allow_nil? true
      end

      argument :country, :string do
        allow_nil? false
      end

      validate argument_in(:points, [nil | Voting.all_points()])
      validate attribute_equals(:final_vote_submitted, false)

      change fn changeset, _ ->
               change_attribute(
                 changeset,
                 :top_10,
                 Voting.give_points(
                   get_attribute(changeset, :top_10),
                   get_argument(changeset, :country),
                   get_argument(changeset, :points)
                 )
               )
             end,
             only_when_valid?: true

      change load(:unused_points)
    end

    update :finalize_top_10 do
      require_atomic? false
      validate attribute_equals(:can_submit_final_vote, true)
      change set_attribute(:final_vote_submitted, true)
    end
  end

  @top_10_derivatives [:top_10_with_points, :used_points, :unused_points, :can_submit_final_vote]

  preparations do
    prepare build(load: @top_10_derivatives)
  end

  changes do
    change load(@top_10_derivatives)
  end

  code_interface do
    define :new, args: [:account_id, :watch_party_id]
    define :for_account, args: [:account_id], action: :for_account
    define :toggle_shortlisted, args: [:country]
    define :toggle_noped, args: [:country]
    define :give_points, args: [:country, :points]
    define :finalize_top_10
  end

  pub_sub do
    module PointexWeb.Endpoint
    publish_all :update, ["participant", :id]
    publish_all :create, ["watch_party", :watch_party_id]
    publish_all :update, ["watch_party", :watch_party_id]
  end

  postgres do
    table "ash_participants"
    repo Pointex.Repo
  end

  defp toggle_country_in_list(changeset, list_attr) do
    current_list = get_attribute(changeset, list_attr) || []
    toggled_country = get_argument(changeset, :country)

    updated_list =
      if toggled_country in current_list do
        Enum.reject(current_list, &(&1 == toggled_country))
      else
        Enum.concat(current_list, [toggled_country])
      end

    change_attribute(changeset, list_attr, updated_list)
  end

  defp remove_country_from_list(changeset, list_attr) do
    toggled_country = get_argument(changeset, :country)

    updated_list =
      changeset
      |> get_attribute(list_attr)
      |> Enum.reject(&(&1 == toggled_country))

    change_attribute(changeset, list_attr, updated_list)
  end
end
