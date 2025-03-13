defmodule Pointex.Europoints.Song do
  use Ash.Resource,
    domain: Pointex.Europoints,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  require Ash.Query
  alias Pointex.Europoints

  attributes do
    attribute :country, :string do
      public? true
      primary_key? true
      allow_nil? false
    end

    attribute :artist, :string do
      public? true
      allow_nil? false
    end

    attribute :name, :string do
      public? true
      allow_nil? false
    end

    attribute :img, :string do
      public? true
      allow_nil? false
    end

    attribute :order_in_sf1, :integer do
      public? true
      constraints min: 1, max: 100
    end

    attribute :order_in_sf2, :integer do
      public? true
      constraints min: 1, max: 100
    end

    attribute :order_in_final, :integer do
      public? true
      constraints min: 1, max: 100
    end

    attribute :actual_place_in_final, :integer do
      public? true
      allow_nil? true
      constraints min: 1, max: 100
    end

    attribute :went_to_final, :boolean do
      public? true
      allow_nil? false
      default false
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
    defaults [:read, :destroy, update: :*]

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

    update :change_description do
      accept [:artist, :name, :img]
    end

    update :went_to_final do
      accept [:went_to_final]
    end

    update :set_actual_place_in_final do
      require_atomic? false
      accept [:actual_place_in_final]
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
            |> Ash.Query.filter(not is_nil(order_in_final))
            |> Ash.Query.sort([:order_in_final])
        end
      end
    end
  end

  preparations do
    prepare build(load: [:flag])
  end

  code_interface do
    define :register
    define :songs_in_show, args: [:year, :kind]
    define :went_to_final, args: [:went_to_final]
    define :set_actual_place_in_final, args: [:actual_place_in_final]
  end

  postgres do
    table "songs"
    repo Pointex.Repo
  end
end
