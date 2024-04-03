defmodule Pointex.Europoints.Show do
  require Ash.Query
  alias Pointex.Europoints

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  attributes do
    uuid_primary_key :id

    attribute :kind, :atom do
      allow_nil? false

      constraints one_of: [:semi_final_1, :semi_final_2, :final]
    end
  end

  relationships do
    belongs_to :season, Europoints.Season do
      allow_nil? false
      attribute_type :integer
      source_attribute :year
      destination_attribute :year
      attribute_writable? true
    end

    # has_many :songs, Europoints.Song do
    #   no_attributes? true

    #   filter expr(year == year and not is_nil(order_in_final))
    # end

    # has_many :songs_manual, Europoints.Song do
    #   no_attributes? true

    #   manual fn shows, %{query: query} = _context ->
    #     years = shows |> Enum.map(& &1.year) |> Enum.uniq()

    #      query
    #      |> Ash.Query.for_read(:read)
    #      |> Ash.Query.filter(year in ^years)
    #      |> Europoints.read()
    #   end
    # end
  end

  actions do
    defaults [:read, :destroy]

    create :new do
      primary? true
      accept [:year, :kind]
    end
  end

  identities do
    identity :show_in_season, [:year, :kind]
  end

  postgres do
    table "ash_shows"
    repo Pointex.Repo
  end
end
