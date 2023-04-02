defmodule Pointex.Model.Commands.RegisterParticipant do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "register_participant" do
    field :pool_id, :string
    field :id, :string
    field :name, :string
  end

  def dispatch_new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:pool_id, :id, :name])
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
    |> Changeset.validate_required([:pool_id, :id, :name])
    |> Changeset.validate_length(:name, min: 2, max: 50)
  end
end
