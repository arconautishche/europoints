defmodule Pointex.Europoints.Show do
  alias Pointex.Europoints

  use Ash.Resource,
    # data_layer: AshPostgres.DataLayer,
    data_layer:
      if(Mix.env() == :test,
        do: Ash.DataLayer.Ets,
        else: AshPostgres.DataLayer
      ),
    extensions: [AshAdmin.Resource]

  actions do
    defaults [:read, :create]
  end

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
    end

    has_many :songs, Europoints.Song do
      no_attributes? true
      filter expr(year == parent.year)
    end
  end

  identities do
    identity :show_in_season, [:year, :kind]
  end

  if Mix.env() != :test do
    require AshPostgres.DataLayer
    import AshPostgres.DataLayer

    postgres do
      table "ash_shows"
      repo Pointex.Repo
    end
  end
end
