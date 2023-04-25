defmodule Pointex.Model.Events.RealResultsPosted do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :points]
end


alias Pointex.Model.Events.RealResultsPosted

defimpl Commanded.Serialization.JsonDecoder, for: RealResultsPosted do
  @doc """
  Switch keys in `top_ten` from atoms like `:"1"` to `1`
  """
  def decode(%RealResultsPosted{points: points_serialized} = event) do
    points_deserialized =
      points_serialized
      |> Enum.map(fn
        {p, s} when is_atom(p) and p != nil ->
          {p |> Atom.to_string() |> String.to_integer(), s}

        {p, s} ->
          {p, s}
      end)
      |> Enum.into(%{})

    %RealResultsPosted{event | points: points_deserialized}
  end
end
