defmodule Pointex.Europoints.Show do
  require Ash.Query
  alias Pointex.Europoints

  use Ash.Resource,
    domain: Pointex.Europoints,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  @kinds [:semi_final_1, :semi_final_2, :final]

  postgres do
    table "ash_shows"
    repo Pointex.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :kind, :atom do
      allow_nil? false
      always_select? true

      constraints one_of: @kinds
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

    has_many :songs, Europoints.Song do
      no_attributes? true

      manual fn shows, %{query: query} = _context ->
        {:ok,
         shows
         |> Enum.map(fn show ->
           songs = Europoints.Song.songs_in_show!(show.year, show.kind)
           %{show_id: show.id, songs: songs}
         end)
         |> Enum.group_by(& &1.show_id)
         |> Enum.map(fn {show_id, songs_wrapped} -> {show_id, Enum.flat_map(songs_wrapped, & &1.songs)} end)
         |> Map.new()}
      end
    end
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

  def kinds(), do: @kinds
end
