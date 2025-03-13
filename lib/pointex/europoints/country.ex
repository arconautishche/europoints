defmodule Pointex.Europoints.Country do
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


  def all do
    Map.keys(@flags)
  end

  def flag(country) do
    Map.get(@flags, country)
  end
end
