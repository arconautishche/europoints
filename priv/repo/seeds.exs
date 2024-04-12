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

# Pointex.Model.ReadModels.Shows.songs(2023)
# |> Enum.map(fn {country, attrs} ->
#   attrs =
#     attrs
#     |> Map.put(:country, country)
#     |> Map.put(:name, attrs.song)
#     |> Map.put(:season, 2023)

#   Europoints.Song
#   |> Ash.Changeset.for_create(:register, attrs)
#   |> Europoints.create!()
# end)

# 2023
# |> Pointex.Model.ReadModels.Shows.songs(:final)
# |> Enum.map(fn %{ro: ro, country: country} ->
#   Europoints.Song
#   |> Europoints.get!(country: country, year: 2023)
#   |> Ash.Changeset.for_update(:update, %{order_in_final: ro})
#   |> Europoints.update!()
# miend)
