defmodule Pointex.Europoints do
  alias Pointex.Europoints

  use Ash.Api,
    extensions: [AshAdmin.Api]

  resources do
    resource Europoints.Account
    resource Europoints.Season
    resource Europoints.Show
    resource Europoints.Song
    resource Europoints.WatchParty
    resource Europoints.Participant
  end

  admin do
    show?(true)
  end
end
