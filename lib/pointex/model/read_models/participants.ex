defmodule Pointex.Model.ReadModels.Participants do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "participants" do
      field :id, :binary_id, primary_key: true
      field :name, :string

      timestamps()
    end
  end

  defmodule Projector do
    use Commanded.Projections.Ecto,
      application: Pointex.Commanded.Application,
      repo: Pointex.Repo,
      name: "participants"

    alias Pointex.Model.Events
    alias Pointex.Model.ReadModels.Participants.Schema

    project(%Events.ParticipantRegistered{} = event, fn multi ->
      %{id: id, name: name} = event

      Ecto.Multi.insert(multi, :participants, %Schema{
        id: id,
        name: name
      })
    end)
  end

  alias Pointex.Repo

  def find(id) do
    case Repo.get(__MODULE__.Schema, id) do
      nil -> :not_found
      participant -> participant
    end
  end

  def all_names() do
    __MODULE__.Schema
    |> Repo.all()
    |> Enum.map(&{&1.id, &1.name})
    |> Enum.into(%{})
  end
end
