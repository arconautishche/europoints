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
end
