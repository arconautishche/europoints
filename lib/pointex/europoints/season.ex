defmodule Pointex.Europoints.Season do
  require Ash.Sort
  alias Pointex.Europoints.Show
  alias Pointex.Europoints.Song

  use Ash.Resource,
    fragments: [Pointex.Europoints.Season.DataLayer],
    extensions: [AshAdmin.Resource]

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

    attribute :active, :boolean do
      allow_nil? false
      default true
    end
  end

  relationships do
    has_many :shows, Show do
      source_attribute :year
      destination_attribute :year
      sort :kind
    end

    has_many :songs, Song do
      source_attribute :year
      destination_attribute :year
      sort :country
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :new do
      primary? true
      accept [:year]

      change fn changeset, _opts ->
        create_and_link_show(changeset, :semi_final_1)
      end

      change fn changeset, _opts ->
        create_and_link_show(changeset, :semi_final_2)
      end

      change fn changeset, _opts ->
        create_and_link_show(changeset, :final)
      end
    end

    update :deactivate do
      change set_attribute(:active, false)
    end

    read :active do
      prepare build(load: [:shows])
      filter expr(active == true)
    end
  end

  code_interface do
    define_for Pointex.Europoints
    define :deactivate
    define :active
  end

  defp create_and_link_show(changeset, kind) do
    Ash.Changeset.manage_relationship(
      changeset,
      :shows,
      %{
        year: changeset.attributes[:year],
        kind: kind
      },
      type: :create
    )
  end

end
