# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pointex.Repo.insert!(%Pointex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pointex.Europoints

# =======================================================================
# SEASON 2023
#

# Pointex.Model.ReadModels.Shows.songs(2023)
# |> Enum.map(fn {country, attrs} ->
#   attrs =
#     attrs
#     |> Map.put(:country, country)
#     |> Map.put(:name, attrs.song)
#     |> Map.put(:season, 2023)

#   Europoints.Song
#   |> Ash.Changeset.for_create(:register, attrs)
#   |> Europoints.create!(upsert?: true)
# end)

# 2023
# |> Pointex.Model.ReadModels.Shows.songs(:semi_final_1)
# |> Enum.map(fn %{ro: ro, country: country} ->
#   Europoints.Song
#   |> Ash.get!(country: country, year: 2023)
#   |> Ash.Changeset.for_update(:update, %{order_in_sf1: ro})
#   |> Ash.update!()
# end)

# 2023
# |> Pointex.Model.ReadModels.Shows.songs(:semi_final_2)
# |> Enum.map(fn %{ro: ro, country: country} ->
#   Europoints.Song
#   |> Ash.get!(country: country, year: 2023)
#   |> Ash.Changeset.for_update(:update, %{order_in_sf2: ro})
#   |> Ash.update!()
# end)

# 2023
# |> Pointex.Model.ReadModels.Shows.songs(:final)
# |> Enum.map(fn %{ro: ro, country: country} ->
#   Europoints.Song
#   |> Ash.get!(country: country, year: 2023)
#   |> Ash.Changeset.for_update(:update, %{order_in_final: ro})
#   |> Ash.update!()
# end)

# =======================================================================
# SEASON 2024
#
alias Pointex.Europoints.Song

"priv/html_2024.html"
|> File.read!()
|> Floki.parse_document!()
|> Floki.find("article")
|> Enum.map(fn article ->
  # Extract the country name and image URL
  country =
    article
    |> Floki.find(".watch-item__country span")
    |> Enum.at(1)
    |> Floki.text()

  artist =
    article
    |> Floki.find(".watch-item__title span")
    |> Floki.text()

  name =
    article
    |> Floki.find(".watch-item__subtitle")
    |> Floki.text()
    |> String.trim()

  image_url =
    article
    |> Floki.find(".watch-item__image img")
    |> hd()
    |> Floki.attribute("src")
    |> hd()

  %{
    season: 2024,
    country: country,
    artist: artist,
    name: name,
    img: "https://eurovision.tv" <> image_url
  }
end)
|> Europoints.bulk_create!(Song, :register,
  return_records?: true,
  upsert?: true,
  upsert_fields: [:artist, :name, :img]
)

sf1_2024 = %{
  1 => "Cyprus",
  2 => "Serbia",
  3 => "Lithuania",
  4 => "Ireland",
  5 => "Ukraine",
  6 => "Poland",
  7 => "Croatia",
  8 => "Iceland",
  9 => "Slovenia",
  10 => "Finland",
  11 => "Moldova",
  12 => "Azerbaijan",
  13 => "Australia",
  14 => "Portugal",
  15 => "Luxembourg"
}

sf2_2024 = %{
  1 => "Malta",
  2 => "Albania",
  3 => "Greece",
  4 => "Switzerland",
  5 => "Czechia",
  6 => "Austria",
  7 => "Denmark",
  8 => "Armenia",
  9 => "Latvia",
  10 => "San Marino",
  11 => "Georgia",
  12 => "Belgium",
  13 => "Estonia",
  14 => "Israel",
  15 => "Norway",
  16 => "Netherlands"
}

final_2024 = %{
  1 => "Sweden",
  2 => "Ukraine",
  3 => "Germany",
  4 => "Luxembourg",
  nil => "Netherlands",
  5 => "Israel",
  6 => "Lithuania",
  7 => "Spain",
  8 => "Estonia",
  9 => "Ireland",
  10 => "Latvia",
  11 => "Greece",
  12 => "United Kingdom",
  13 => "Norway",
  14 => "Italy",
  15 => "Serbia",
  16 => "Finland",
  17 => "Portugal",
  18 => "Armenia",
  19 => "Cyprus",
  20 => "Switzerland",
  21 => "Slovenia",
  22 => "Croatia",
  23 => "Georgia",
  24 => "France",
  25 => "Austria"
}

Enum.map(sf1_2024, fn {place, country} ->
  Song
  |> Ash.get!(year: 2024, country: country)
  |> Ash.Changeset.for_update(:update, %{order_in_sf1: place})
  |> Ash.update!()
end)

Enum.map(sf2_2024, fn {place, country} ->
  Song
  |> Ash.get!(year: 2024, country: country)
  |> Ash.Changeset.for_update(:update, %{order_in_sf2: place})
  |> Ash.update!()
end)

Enum.map(final_2024, fn {place, country} ->
  Song
  |> Ash.get!(year: 2024, country: country)
  |> Ash.Changeset.for_update(:update, %{order_in_final: place})
  |> Ash.update!()
end)
