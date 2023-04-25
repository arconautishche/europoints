defmodule Pointex.Model.ReadModels.WatchPartyResults do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "watch_party_results" do
      field :id, :binary_id, primary_key: true

      embeds_many :songs, Song, primary_key: false, on_replace: :delete do
        field :id, :string, primary_key: true
        field :details, :map
        field :points, :integer
      end

      embeds_many :predictions_top, PredictionTop, primary_key: false, on_replace: :delete do
        field :participant_id, :string, primary_key: true
        field :score, :integer
      end

      timestamps()
    end
  end

  defmodule Projector do
    use Commanded.Projections.Ecto,
      application: Pointex.Commanded.Application,
      repo: Pointex.Repo,
      name: "watch_party_results"

    alias PointexWeb.Endpoint
    alias Ecto.Changeset
    alias Pointex.Model.Events
    alias Pointex.Model.ReadModels.WatchPartyResults
    alias Pointex.Model.ReadModels.Shows

    project(%Events.WatchPartyStarted{} = event, fn multi ->
      %{id: id, owner_id: participant_id, year: year, show: show} = event

      Ecto.Multi.insert(multi, :watch_party_results, %WatchPartyResults.Schema{
        id: id,
        songs: all_songs(year, String.to_atom(show)),
        predictions_top: [new_participant(participant_id)]
      })
    end)

    project(%Events.ParticipantJoinedWatchParty{} = event, fn multi ->
      %{id: id, participant_id: participant_id} = event

      results = WatchPartyResults.get(id)

      update =
        results
        |> Changeset.change()
        |> Changeset.put_embed(
          :predictions_top,
          results.predictions_top ++ [new_participant(participant_id)]
        )

      Ecto.Multi.update(multi, :watch_party_results, update)
    end)

    project(%Events.WatchPartyTotalsUpdated{} = event, fn multi ->
      %{watch_party_id: id, totals: totals} = event

      results = WatchPartyResults.get(id)

      update =
        results
        |> Changeset.change()
        |> Changeset.put_embed(
          :songs,
          replace_totals(results.songs, totals)
        )

      Ecto.Multi.update(multi, :watch_party_results, update)
    end)

    @impl Commanded.Projections.Ecto
    def after_update(%{id: id} = _event, _metadata, _changes) do
      Endpoint.broadcast("watch_party_results:#{id}", "updated", %{})
      :ok
    end

    def after_update(event, _metadata, _changes) do
      Endpoint.broadcast("watch_party_results:#{event.watch_party_id}", "updated", %{})
      :ok
    end

    defp all_songs(year, show) do
      year
      |> Shows.songs(show)
      |> Enum.map(fn song_details ->
        %{
          id: song_details.country,
          details: song_details,
          points: 0
        }
      end)
    end

    defp new_participant(id) do
      %{participant_id: id, score: 0}
    end

    defp replace_totals(songs, totals) do
      Enum.map(songs, fn s ->
        Ecto.Changeset.change(s, %{points: Map.get(totals, s.id, 0)})
      end)
    end
  end

  alias Pointex.Repo

  def get(id) do
    Repo.get(__MODULE__.Schema, id)
  end
end
