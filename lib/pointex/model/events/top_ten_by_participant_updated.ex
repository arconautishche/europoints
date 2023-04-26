defmodule Pointex.Model.Events.TopTenByParticipantUpdated do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :participant_id, :final?, :top_ten]
end

alias Pointex.Model.Events.TopTenByParticipantUpdated

defimpl Commanded.Serialization.JsonDecoder, for: TopTenByParticipantUpdated do
  @doc """
  Switch keys in `top_ten` from atoms like `:"1"` to `1`
  """
  def decode(%TopTenByParticipantUpdated{top_ten: top_ten_serialized} = event) do
    top_ten_deserialized =
      top_ten_serialized
      |> Enum.map(fn
        {p, s} when is_atom(p) and p != nil ->
          {p |> Atom.to_string() |> String.to_integer(), s}

        {p, s} ->
          {p, s}
      end)
      |> Enum.into(%{})

    %TopTenByParticipantUpdated{event | top_ten: top_ten_deserialized}
  end
end
