defmodule Pointex.Model.Commands.StartWatchParty do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "start_watch_party_command" do
    field :id, :string
    field :owner_id, :string
    field :name, :string
  end

  def new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:id, :owner_id, :name])
    |> validate()
  end

   def dispatch_new(attrs) do
    attrs
    |> new()
    |> case do
      {:errors, changeset} ->
        {:errors, changeset}

      {:ok, command} ->
        CommandedApp.dispatch(command)
    end
  end

  defp validate(changeset) do
    changeset
    |> Changeset.validate_required([:id, :owner_id, :name])
    |> Changeset.validate_length(:name, min: 3, max: 50)
    |> case do
      %{valid?: false} = changeset -> {:errors, changeset}
      changeset -> Changeset.apply_action(changeset, :new)

    end
  end
end
