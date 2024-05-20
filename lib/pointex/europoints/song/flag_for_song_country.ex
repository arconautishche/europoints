defmodule Pointex.Europoints.Song.FlagForSongCountry do
  use Ash.Resource.Calculation

  @flags %{
    "Sweden" => "🇸🇪",
    "Greece" => "🇬🇷",
    "France" => "🇫🇷",
    "Armenia" => "🇦🇲",
    "San Marino" => "🇸🇲",
    "United Kingdom" => "🇬🇧",
    "Serbia" => "🇷🇸",
    "Spain" => "🇪🇸",
    "Ireland" => "🇮🇪",
    "Moldova" => "🇲🇩",
    "Denmark" => "🇩🇰",
    "Israel" => "🇮🇱",
    "Czechia" => "🇨🇿",
    "Malta" => "🇲🇹",
    "Albania" => "🇦🇱",
    "Slovenia" => "🇸🇮",
    "Poland" => "🇵🇱",
    "Lithuania" => "🇱🇹",
    "Iceland" => "🇮🇸",
    "Switzerland" => "🇨🇭",
    "Cyprus" => "🇨🇾",
    "Belgium" => "🇧🇪",
    "Croatia" => "🇭🇷",
    "Austria" => "🇦🇹",
    "Latvia" => "🇱🇻",
    "Azerbaijan" => "🇦🇿",
    "Australia" => "🇦🇺",
    "Estonia" => "🇪🇪",
    "Finland" => "🇫🇮",
    "Ukraine" => "🇺🇦",
    "Netherlands" => "🇳🇱",
    "Norway" => "🇳🇴",
    "Portugal" => "🇵🇹",
    "Germany" => "🇩🇪",
    "Georgia" => "🇬🇪",
    "Romania" => "🇷🇴",
    "Italy" => "🇮🇹",
    "Luxembourg" => "🇱🇺"
  }

  @impl true
  def calculate(records, _opts, _context) do
    Enum.map(records, fn %{country: country} -> @flags[country] end)
  end
end
