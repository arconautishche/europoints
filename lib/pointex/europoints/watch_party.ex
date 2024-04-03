defmodule Pointex.Europoints.WatchParty do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  require Ash.Resource.Change.Builtins
  alias Pointex.Europoints

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :show, Europoints.Show do
      allow_nil? false
    end

    has_many :participants, Europoints.Participant do
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :start do
      primary? true

      argument :name, :string do
        allow_nil? false
      end

      argument :owner_account_id, :uuid do
        allow_nil? false
      end

      argument :show_id, :uuid do
        allow_nil? false
      end

      change set_attribute(:name, arg(:name))

      change manage_relationship(:show_id, :show,
               type: :append_and_remove,
               value_is_key: :id
             )

      change fn changeset, _opts ->
        Ash.Changeset.manage_relationship(
          changeset,
          :participants,
          %{
            account_id: changeset.arguments[:owner_account_id],
            owner: true
          },
          type: :create
        )
      end
    end
  end

  code_interface do
    define_for Pointex.Europoints

    define :start, args: [:name, :owner_account_id, :show_id]
  end

  postgres do
    table "ash_watch_parties"
    repo Pointex.Repo
  end
end
