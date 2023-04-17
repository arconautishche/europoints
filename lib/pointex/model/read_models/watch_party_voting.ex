defmodule Pointex.Model.ReadModels.WatchPartyVoting do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "watch_party_voting" do
      field :id, :binary_id, primary_key: true
      field :participant_id, :binary_id, primary_key: true

      embeds_many :songs, Song, primary_key: false, on_replace: :delete do
        field :id, :string, primary_key: true
        field :details, :map
        field :viewing_result, Ecto.Enum, values: [:shortlisted, :noped, :meh]
        field :points, :integer
      end

      timestamps()
    end
  end

  defmodule Projector do
    use Commanded.Projections.Ecto,
      application: Pointex.Commanded.Application,
      repo: Pointex.Repo,
      name: "watch_party_voting"

    alias PointexWeb.Endpoint
    alias Ecto.Changeset
    alias Pointex.Model.Events
    alias Pointex.Model.ReadModels.WatchPartyVoting
    alias Pointex.Model.ReadModels.Shows

    project(%Events.WatchPartyStarted{} = event, fn multi ->
      %{id: id, owner_id: participant_id, year: year, show: show} = event

      Ecto.Multi.insert(multi, :watch_party_voting, %WatchPartyVoting.Schema{
        id: id,
        participant_id: participant_id,
        songs: all_songs(year, String.to_atom(show))
      })
    end)

    project(%Events.SongShortlistedChanged{} = event, fn multi ->
      %{watch_party_id: id, participant_id: participant_id, song_id: song_id} = event

      update_song_in_watch_party(multi, id, participant_id, song_id, fn
        %{viewing_result: :shortlisted} ->
          if event.shortlisted, do: %{}, else: %{viewing_result: :meh}

        _ ->
          if event.shortlisted, do: %{viewing_result: :shortlisted}, else: %{}
      end)
    end)

    project(%Events.SongNopedChanged{} = event, fn multi ->
      %{watch_party_id: id, participant_id: participant_id, song_id: song_id} = event

      update_song_in_watch_party(multi, id, participant_id, song_id, fn
        %{viewing_result: :noped} ->
          if event.noped, do: %{}, else: %{viewing_result: :meh}

        _ ->
          if event.noped, do: %{viewing_result: :noped}, else: %{}
      end)
    end)

    project(%Events.TopTenByParticipantUpdated{} = event, fn multi ->
      %{watch_party_id: id, participant_id: participant_id} = event

      viewing = WatchPartyVoting.get(id, participant_id)

      update =
        viewing
        |> Changeset.change()
        |> Changeset.put_embed(
          :songs,
          change_songs(viewing, fn _ -> true end, fn song ->
            IO.inspect(song, label: "song")

            %{
              points:
                Enum.find_value(
                  event.top_ten,
                  0,
                  fn {p, s} -> if s == song.id, do: p end
                )
            }
            |> IO.inspect(label: "points")
          end)
        )

      Ecto.Multi.update(multi, :watch_party_voting, update)
    end)

    @impl Commanded.Projections.Ecto
    def after_update(%{id: id} = _event, _metadata, _changes) do
      Endpoint.broadcast("watch_party_voting:#{id}", "updated", %{})
      :ok
    end

    def after_update(event, _metadata, _changes) do
      Endpoint.broadcast("watch_party_voting:#{event.watch_party_id}", "updated", %{})
      :ok
    end

    defp all_songs(year, show) do
      year
      |> Shows.songs(show)
      |> Enum.map(fn song_details ->
        %{
          id: song_details.country,
          details: song_details,
          viewing_result: :meh,
          points: 0
        }
      end)
    end

    defp update_song_in_watch_party(multi, id, participant_id, song_id, update_fn) do
      viewing = WatchPartyVoting.get(id, participant_id)

      update =
        viewing
        |> Changeset.change()
        |> Changeset.put_embed(
          :songs,
          change_songs(viewing, &(&1.id == song_id), update_fn)
        )

      Ecto.Multi.update(multi, :watch_party_voting, update)
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