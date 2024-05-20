defmodule Pointex.Europoints.Song.FlagForSongCountry do
  use Ash.Resource.Resource.Calculation
  alias Pointex.Europoints.Country

  @impl true
  def calculate(records, _opts, _context) do
    Enum.map(records, fn %{country: country} -> Country.flag(country) end)
  end
end
