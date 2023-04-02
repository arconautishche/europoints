defmodule Pointex.Model.ReadModels.MyWatchParties do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "my_watch_parties" do
      field :id, :binary_id
      field :participant_id, :binary_id
      field :name, :string
      field :year, :integer, default: 2003
      field :show, Ecto.Enum, values: [:semi_final_1, :semi_final_2, :final], default: :semi_final_1

      timestamps()
    end
  end

  defmodule Projector do
    use Commanded.Projections.Ecto,
      application: Pointex.Commanded.Application,
      repo: Pointex.Repo,
      name: "my_watch_parties"

      alias Pointex.Model.Events
      alias Pointex.Model.ReadModels.MyWatchParties

    project(%Events.WatchPartyStarted{} = event, fn multi ->
      %{owner_id: owner_id, id: id, name: name} = event
      Ecto.Multi.insert(multi, :my_watch_parties, %MyWatchParties.Schema{id: id, participant_id: owner_id, name: name})
    end)

  end

  import Ecto.Query
  alias Pointex.Repo

  def for(participant_id) do
    __MODULE__.Schema
    |> where(participant_id: ^participant_id)
    |> Repo.all()
  end
end
