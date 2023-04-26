defmodule Pointex.Model.Commands.PostRealResults do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "give_points_to_song" do
    field :watch_party_id, :binary_id
    field :points, :map
  end

  def dispatch_new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:watch_party_id, :points])
    |> validate()
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
    |> Changeset.validate_required([:watch_party_id, :points])
    |> Changeset.validate_change(:points, fn :points, points ->
      if points |> Map.keys() |> Enum.sort() == [
           "1",
           "10",
           "12",
           "2",
           "3",
           "4",
           "5",
           "6",
           "7",
           "8"
         ] do
        []
      else
        [points: "incorrect"]
      end
    end)
    |> Changeset.validate_change(:points, fn :points, points ->
      if Enum.any?(points, fn {_p, s} -> is_nil(s) || s == "" end) do
        [points: "incomplete"]
      else
        []
      end
    end)
    |> Changeset.validate_change(:points, fn :points, points ->
      if points |> Map.values() |> Enum.uniq() |> Enum.count() != 10 do
        [points: "duplicates"]
      else
        []
      end
    end)
  end
end
