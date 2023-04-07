defmodule Pointex.Model.ReadModels.WatchPartyViewing do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "watch_party_viewing" do
      field :id, :binary_id, primary_key: true
      field :participant_id, :binary_id, primary_key: true

      embeds_many :songs, Song, primary_key: false, on_replace: :delete do
        field :id, :string, primary_key: true
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

    alias PointexWeb.Endpoint
    alias Ecto.Changeset
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

    project(%Events.SongShortlisted{} = event, fn multi ->
      %{watch_party_id: id, participant_id: participant_id, song_id: song_id} = event
      update_song_in_watch_party(multi, id, participant_id, song_id,  & %{shortlisted: !&1.shortlisted, noped: false})
    end)

    project(%Events.SongNoped{} = event, fn multi ->
      %{watch_party_id: id, participant_id: participant_id, song_id: song_id} = event
      update_song_in_watch_party(multi, id, participant_id, song_id,  & %{noped: !&1.noped, shortlisted: false})
    end)

    @impl Commanded.Projections.Ecto
    def after_update(event, _metadata, _changes) do
      Endpoint.broadcast("watch_party_viewing:#{event.watch_party_id}", "updated", %{})
      :ok
    end

    defp all_songs(year, show) do
      year
      |> Shows.songs(show)
      |> Enum.map(fn song_details ->
        %{
          id: song_details.country,
          details: song_details,
          shortlisted: false,
          noped: false
        }
      end)
    end

    defp update_song_in_watch_party(multi, id, participant_id, song_id, update_fn) do
      viewing = WatchPartyViewing.get(id, participant_id)

      update =
        viewing
        |> Changeset.change()
        |> Changeset.put_embed(
          :songs,
          change_songs(viewing, &(&1.id == song_id), update_fn)
        )

      Ecto.Multi.update(multi, :watch_party_viewing, update)
    end

    defp change_songs(viewing, matcher, changes_to_apply) do
      viewing
      |> Map.get(:songs)
      |> Enum.map(fn song ->
        Changeset.change(
          song,
          if(matcher.(song), do: changes_to_apply.(song), else: %{})
        )
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
