defmodule Pointex.Model.Commands.GivePointsToSong do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "give_points_to_song" do
    field :watch_party_id, :binary_id
    field :participant_id, :binary_id
    field :song_id, :string
    field :points, :integer
  end

  def dispatch_new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:watch_party_id, :participant_id, :song_id, :points])
    |> validate()
    |> IO.inspect(label: "Commands.GivePointsToSong")
    |> case do
      %{valid?: false} = changeset ->
        {:errors, changeset}

      valid_changeset ->
        valid_changeset
        |> Changeset.apply_action!(:new)
        |> CommandedApp.dispatch()
    end
  end

  defp validate(changeset) do
    changeset
    |> Changeset.validate_required([:watch_party_id, :participant_id, :song_id])
    |> Changeset.validate_inclusion(:points, [nil, 1, 2, 3, 4, 5, 6, 7, 8, 10, 12])
  end
end
