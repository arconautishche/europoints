defmodule Pointex.Model.ReadModels.MyWatchParties do
  defmodule Schema do
    use Ecto.Schema

    @primary_key false
    schema "my_watch_parties" do
      field :id, :binary_id
      field :participant_id, :binary_id
      field :name, :string
      field :year, :integer, default: 2023

      field :show, Ecto.Enum,
        values: [:semi_final_1, :semi_final_2, :final],
        default: :semi_final_1

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
    alias Ecto.Changeset

    project(%Events.ParticipantJoinedWatchParty{} = event, fn multi ->
      Ecto.Multi.insert(
        multi,
        :my_watch_parties,
        %MyWatchParties.Schema{}
        |> Changeset.cast(
          %{
            id: event.id,
            participant_id: event.participant_id,
            name: event.name,
            year: event.year,
            show: event.show
          },
          [:id, :participant_id, :name, :year, :show]
        )
      )
    end)
  end

  import Ecto.Query
  alias Pointex.Repo

  def for(participant_id) do
    __MODULE__.Schema
    |> where(participant_id: ^participant_id)
    |> Repo.all()
    |> Enum.map(fn wp -> with_names_of_participants(wp) end)
  end

  def by_id(id_str) do
    case Ecto.UUID.cast(id_str) do
      :error ->
        nil

      {:ok, id} ->
        __MODULE__.Schema
        |> where(id: ^id)
        |> Repo.all()
        |> List.first()
        |> with_names_of_participants()
    end
  end

  defp with_names_of_participants(wp)
  defp with_names_of_participants(nil), do: nil

  defp with_names_of_participants(%__MODULE__.Schema{id: wp_id} = wp) do
    names = []

    other_participants =
      __MODULE__.Schema
      |> where(id: ^wp_id)
      |> select([w], w.participant_id)
      |> Repo.all()
      |> Enum.map(&%{id: &1, name: Map.get(names, &1)})

    wp
    |> Map.from_struct()
    |> Map.merge(%{other_participants: other_participants})
  end
end
