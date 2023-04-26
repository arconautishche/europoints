defmodule Pointex.Model.Commands.FinalizeParticipantsVote do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "finalize_participants_vote" do
    field :watch_party_id, :binary_id
    field :participant_id, :binary_id
  end

  def dispatch_new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:watch_party_id, :participant_id])
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
    |> Changeset.validate_required([:watch_party_id, :participant_id])
  end
end
