defmodule Pointex.Europoints.Account do
  use Ash.Resource,
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

  actions do
    defaults [:create, :read, :update, :destroy]

    create :register do
      accept [:name]
    end
  end

  code_interface do
    define_for Pointex.Europoints

    define :register, args: [:name]
  end

  postgres do
    table "ash_accounts"
    repo Pointex.Repo
  end
end
