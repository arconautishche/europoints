defmodule Pointex.Europoints.Participant.Voting do
  @points [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
  @points_indeces @points |> Enum.with_index() |> Map.new()

  def all_points(), do: @points

  def points(top_10_with_points, predicate) do
    top_10_with_points
    |> Enum.filter(predicate)
    |> Enum.map(fn {points, _song} -> points end)
    |> Enum.sort(:desc)
  end

  def give_points(top_10, country, points) do
    insertion_index = @points_indeces[points] || 10

    top_10
    |> remove_country(country)
    |> prepare_place_to_insert(insertion_index)
    |> List.insert_at(insertion_index, country)
    |> Enum.take(10)
  end

  defp remove_country(top_10, country) do
    Enum.map(top_10, fn
      ^country -> nil
      other_choice -> other_choice
    end)
  end

  defp prepare_place_to_insert(top_10, insertion_index) do
    case Enum.at(top_10, insertion_index) do
      nil ->
        List.delete_at(top_10, insertion_index)

      _ ->
        first_empty_space =
          top_10
          |> Enum.with_index()
          |> Enum.slice(insertion_index..10)
          |> Enum.find_value(fn {song, index} -> if song == nil, do: index end)

        if first_empty_space == nil do
          top_10
        else
          List.delete_at(top_10, first_empty_space)
        end
    end
  end
end
