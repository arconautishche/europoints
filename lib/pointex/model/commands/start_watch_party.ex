defmodule Pointex.Model.Commands.StartWatchParty do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Pointex.Commanded.Application, as: CommandedApp

  @primary_key false
  schema "start_watch_party_command" do
    field :id, :string
    field :owner_id, :string
    field :name, :string
    field :year, :integer
    field :show, Ecto.Enum, values: [:semi_final_1, :semi_final_2, :final]
  end

  def new(attrs) do
    %__MODULE__{}
    |> Changeset.cast(attrs, [:id, :owner_id, :name, :year, :show])
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
    |> Changeset.validate_required([:id, :owner_id, :name, :year, :show])
    |> Changeset.validate_length(:name, min: 3, max: 50)
    |> Changeset.validate_number(:year, greater_than: 1956)
    |> Changeset.validate_inclusion(:show, Ecto.Enum.values(__MODULE__, :show))
    |> case do
      %{valid?: false} = changeset -> {:errors, changeset}
      changeset -> Changeset.apply_action(changeset, :new)
    end
  end
end
