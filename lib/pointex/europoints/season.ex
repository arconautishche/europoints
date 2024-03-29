defmodule Pointex.Europoints.Season do
  alias Pointex.Europoints.Show

  use Ash.Resource,
    # data_layer:
    #   if(Mix.env() == :test,
    #     do: Ash.DataLayer.Ets,
    #     else: AshPostgres.DataLayer
    #   ),
    fragments: [Pointex.Europoints.Season.DataLayer],
    extensions: [AshAdmin.Resource]

  actions do
    defaults [:read, :update, :destroy]

    create :new do
      accept [:year]

      argument :sf1, :map, default: %{year: arg(:year), kind: :semi_final_1}
      argument :sf2, :map, default: %{year: arg(:year), kind: :semi_final_2}
      argument :final, :map, default: %{year: arg(:year), kind: :final}

      change manage_relationship(:sf1, :shows, type: :create)
      change manage_relationship(:sf2, :shows, type: :create)
      change manage_relationship(:final, :shows, type: :create)
    end
  end

  code_interface do
    define_for Pointex.Europoints

    define :new, args: [:year]
  end

  attributes do
    attribute :year, :integer do
      primary_key? true
      allow_nil? false

      constraints min: 1956
    end
  end

  relationships do
    has_many :shows, Show do
      source_attribute :year
      destination_attribute :year
      sort :kind
    end
  end
end
