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
  end

  code_interface do
    define_for Pointex.Europoints

    define :new, args: [:account_id, :watch_party_id]
  end

  postgres do
    table "ash_participants"
    repo Pointex.Repo
  end
end
