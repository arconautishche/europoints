defmodule Pointex.Europoints.Song do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource],
    fragments: []

  alias Pointex.Europoints

  actions do
    defaults [:read, :update, :destroy]

    create :register do
      primary? true

      accept [:country, :flag, :artist, :name, :img]

      argument :season, :integer do
        allow_nil? false
      end

      change manage_relationship(:season, :season,
               type: :append_and_remove,
               value_is_key: :year
             )
    end

    read :songs_in_season do
      argument :year, :integer do
        allow_nil? false
      end

      prepare build(sort: [country: :asc])

      filter expr(year == ^arg(:year))
    end
  end

  attributes do
    attribute :country, :string do
      primary_key? true
      allow_nil? false
    end

    attribute :flag, :string do
      allow_nil? false
    end

    attribute :artist, :string do
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
    end

    attribute :img, :string do
      allow_nil? false
    end

    attribute :order_in_sf1, :integer do
      constraints min: 1, max: 100
    end

    attribute :order_in_sf2, :integer do
      constraints min: 1, max: 100
    end

    attribute :order_in_final, :integer do
      constraints min: 1, max: 100
    end

    attribute :final_place, :integer do
      constraints min: 1, max: 100
    end
  end

  relationships do
    belongs_to :season, Europoints.Season do
      primary_key? true
      allow_nil? false
      attribute_type :integer
      source_attribute :year
      destination_attribute :year
    end
  end

  postgres do
    table "songs"
    repo Pointex.Repo
  end
end
