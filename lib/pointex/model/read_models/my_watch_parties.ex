defmodule Pointex.Model.ReadModels.MyWatchParties do
  use Ecto.Schema
  import Ecto.Query
  alias Pointex.Repo

  @primary_key false
  schema "my_watch_parties" do
    field :id, :binary_id
    field :participant_id, :binary_id
    field :name, :string

    timestamps()
  end

  def for(participant_id) do
    __MODULE__
    |> where(participant_id: ^participant_id)
    |> Repo.all()
  end
end
