defmodule Pointex.Europoints.Season.DataLayer do
  use Spark.Dsl.Fragment,
    of: Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "ash_seasons"
    repo Pointex.Repo
  end
end
