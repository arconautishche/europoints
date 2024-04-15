defmodule Pointex.Europoints.Song do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource],
    fragments: []

  require Ash.Query
  alias Pointex.Europoints

  attributes do
    attribute :country, :string do
      primary_key? true
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

  calculations do
    calculate :flag, :string, Europoints.Song.FlagForSongCountry
  end

  identities do
    identity :song_in_season, [:year, :country]
  end

  actions do
    defaults [:read, :update, :destroy]

    create :register do
      primary? true

      accept [:country, :artist, :name, :img]

      argument :season, :integer do
        allow_nil? false
      end

      change manage_relationship(:season, :season,
               type: :append_and_remove,
               value_is_key: :year
             )
    end

    read :songs_in_show do
      argument :year, :integer do
        allow_nil? false
      end

      @show_kinds Europoints.Show.kinds()
      argument :kind, :atom do
        constraints one_of: @show_kinds
      end

      prepare fn query, _context ->
        year_arg = Ash.Query.get_argument(query, :year)
        kind_arg = Ash.Query.get_argument(query, :kind)

        filtered_on_year =
          query
          |> Ash.Query.filter(year == ^year_arg)
          |> Ash.Query.load([:flag])

        case kind_arg do
          :semi_final_1 ->
            filtered_on_year
            |> Ash.Query.filter(not is_nil(order_in_sf1))
            |> Ash.Query.sort([:order_in_sf1])

          :semi_final_2 ->
            filtered_on_year
            |> Ash.Query.filter(not is_nil(order_in_sf2))
            |> Ash.Query.sort([:order_in_sf2])

          :final ->
            filtered_on_year
            |> Ash.Query.filter(not is_nil(final))
            |> Ash.Query.sort([:final])
        end
      end
    end
  end

  code_interface do
    define_for Europoints

    define :register
    define :songs_in_show, args: [:year, :kind]
  end

  postgres do
    table "songs"
    repo Pointex.Repo
  end
end
