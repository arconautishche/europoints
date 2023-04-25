defmodule Pointex.Model.Events.WatchPartyTotalsUpdated do
  @derive Jason.Encoder
  defstruct [:watch_party_id, :totals]
end

alias Pointex.Model.Events.WatchPartyTotalsUpdated

defimpl Commanded.Serialization.JsonDecoder, for: WatchPartyTotalsUpdated do
  @doc """
  Switch keys in `top_ten` from atoms like `:"1"` to `1`
  """
  def decode(%WatchPartyTotalsUpdated{totals: totals_serialized} = event) do
    totals_deserialized =
      totals_serialized
      |> Enum.map(fn
        {s, p} when is_atom(s) and s != nil ->
          {Atom.to_string(s), p}

        {s, p} ->
          {s, p}
      end)
      |> Enum.into(%{})

    %WatchPartyTotalsUpdated{event | totals: totals_deserialized}
  end
end
