defmodule Pointex.Europoints.Participant do
  alias Pointex.Europoints

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

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
  end

  relationships do
    belongs_to :account, Europoints.Account do
      private? false
      allow_nil? false
    end

    belongs_to :watch_party, Europoints.WatchParty do
      attribute_writable? true
      allow_nil? false
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :new do
      primary? true

      argument :account_id, :uuid do
        allow_nil? false
      end

      accept [:owner]

      change manage_relationship(:account_id, :account,
               type: :append_and_remove,
               value_is_key: :id,
               on_lookup: :relate
             )
    end

    read :for_account do
      argument :account_id, :uuid do
        allow_nil? false
      end

      prepare build(load: [:watch_party, :account])

      prepare fn query, _ ->
        require Ash.Query
        Ash.Query.filter(query, account.id == arg(:account_id))
      end
    end

    update :toggle_shortlisted do
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
      argument :country, :string do
        allow_nil? false
      end

      change fn changeset, _ ->
        changeset
        |> toggle_country_in_list(:noped)
        |> remove_country_from_list(:shortlist)
      end
    end
  end

  code_interface do
    define_for Pointex.Europoints

    define :new, args: [:account_id, :watch_party_id]
    define :for_account, args: [:account_id], action: :for_account
    define :toggle_shortlisted, args: [:country]
    define :toggle_noped, args: [:country]
  end

  postgres do
    table "ash_participants"
    repo Pointex.Repo
  end

  defp toggle_country_in_list(changeset, list_attr) do
    current_list = Ash.Changeset.get_attribute(changeset, list_attr) || []
    toggled_country = Ash.Changeset.get_argument(changeset, :country)

    updated_list =
      if toggled_country in current_list do
        Enum.reject(current_list, &(&1 == toggled_country))
      else
        Enum.concat(current_list, [toggled_country])
      end

    Ash.Changeset.change_attribute(changeset, list_attr, updated_list)
  end

  defp remove_country_from_list(changeset, list_attr) do
    toggled_country = Ash.Changeset.get_argument(changeset, :country)

    updated_list =
      changeset
      |> Ash.Changeset.get_attribute(list_attr)
      |> Enum.reject(&(&1 == toggled_country))

    Ash.Changeset.change_attribute(changeset, list_attr, updated_list)
  end
end
