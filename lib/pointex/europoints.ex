defmodule Pointex.Europoints do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  resources do
    resource Pointex.Europoints.Season
    resource Pointex.Europoints.Show
    resource Pointex.Europoints.Song
    resource Pointex.Europoints.WatchParty
    resource Pointex.Europoints.Participant
  end

  admin do
    show?(true)
  end
end
