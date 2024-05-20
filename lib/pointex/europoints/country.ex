defmodule Pointex.Europoints.Country do
  @flags %{
    "Albania" => "🇦🇱",
    "Armenia" => "🇦🇲",
    "Austria" => "🇦🇹",
    "Bulgaria" => "🇧🇬",
    "Sweden" => "🇸🇪",
    "Greece" => "🇬🇷",
    "France" => "🇫🇷",
    "San Marino" => "🇸🇲",
    "United Kingdom" => "🇬🇧",
    "Serbia" => "🇷🇸",
    "Spain" => "🇪🇸",
    "Ireland" => "🇮🇪",
    "Denmark" => "🇩🇰",
    "Israel" => "🇮🇱",
    "Czechia" => "🇨🇿",
    "Malta" => "🇲🇹",
    "Moldova" => "🇲🇩",
    "Montenegro" => "🇲🇪",
    "Slovenia" => "🇸🇮",
    "Poland" => "🇵🇱",
    "Lithuania" => "🇱🇹",
    "Iceland" => "🇮🇸",
    "Switzerland" => "🇨🇭",
    "Cyprus" => "🇨🇾",
    "Belgium" => "🇧🇪",
    "Croatia" => "🇭🇷",
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

  def all do
    Map.keys(@flags)
  end

  def flag(country) do
    Map.get(@flags, country)
  end
end
