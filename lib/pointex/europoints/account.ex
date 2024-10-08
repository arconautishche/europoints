defmodule Pointex.Europoints.Account do
  alias Pointex.Europoints.Participant

  use Ash.Resource,
    domain: Pointex.Europoints,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  resource do
    description """
    An account representing a unique returning user.
    """
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    has_many :participants, Participant
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :register do
      accept [:name]
    end
  end

  code_interface do
    define :register, args: [:name]
  end

  postgres do
    table "ash_accounts"
    repo Pointex.Repo
  end
end
