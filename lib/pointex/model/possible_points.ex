defmodule Pointex.Model.PossiblePoints do
  @possible_votes_asc 1..8
                      |> Enum.to_list()
                      |> Kernel.++([10, 12])

  @possible_votes_desc 1..8
                       |> Enum.to_list()
                       |> Kernel.++([10, 12])
                       |> Enum.reverse()

  def asc(), do: @possible_votes_asc
  def desc(), do: @possible_votes_desc

  def inc(12), do: nil
  def inc(10), do: 12
  def inc(8), do: 10
  def inc(points), do: points + 1

  def dec(12), do: 10
  def dec(10), do: 8
  def dec(1), do: nil
  def dec(points), do: points - 1
end
