defmodule Pointex.Europoints.WatchParty do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  alias Pointex.Europoints

  actions do
    defaults [:read, :update, :destroy]

    create :start do
      primary? true

      accept [:name]

      argument :owner_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:owner_id, :owner,
               type: :append_and_remove,
               value_is_key: :id,
               on_lookup: :relate
             )
    end
  end

  code_interface do
    define_for Pointex.Europoints

    define :start, args: [:name, :owner_id]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :owner, Europoints.Participant do
      allow_nil? false
    end

    belongs_to :show, Europoints.Show do
      allow_nil? false
    end
  end

  postgres do
    table "ash_watch_parties"
    repo Pointex.Repo
  end
end
