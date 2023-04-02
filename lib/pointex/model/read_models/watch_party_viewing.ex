defmodule Pointex.Model.ReadModels.WatchPartyViewing do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "watch_party_viewing" do
      field :id, :binary_id
      field :participant_id, :binary_id

      embeds_many :songs, Song do
        field :details, :map
        field :shortlisted, :boolean, default: false
        field :noped, :boolean, default: false
      end

      timestamps()
    end
  end

  defmodule Projector do
    use Commanded.Projections.Ecto,
      application: Pointex.Commanded.Application,
      repo: Pointex.Repo,
      name: "watch_party"

    alias Pointex.Model.Events
    alias Pointex.Model.ReadModels.WatchPartyViewing
    alias Pointex.Model.ReadModels.Shows

    project(%Events.WatchPartyStarted{} = event, fn multi ->
      %{id: id, owner_id: participant_id, year: year, show: show} = event

      Ecto.Multi.insert(multi, :watch_party_viewing, %WatchPartyViewing.Schema{
        id: id,
        participant_id: participant_id,
        songs: all_songs(year, String.to_atom(show))
      })
    end)

    defp all_songs(year, show) do
      year
      |> Shows.songs(show)
      |> Enum.map(fn song_details ->
        %{
          details: song_details,
          shortlisted: false,
          noped: false
        }
      end)
    end
  end

  alias Pointex.Repo
  import Ecto.Query

  def get(id, participant_id) do
    __MODULE__.Schema
    |> where(id: ^id)
    |> where(participant_id: ^participant_id)
    |> Repo.one()
  end
end
