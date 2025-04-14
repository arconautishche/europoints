defmodule Pointex.Europoints do
  alias Pointex.Europoints

  use Ash.Domain,
    extensions: [AshAdmin.Domain]

  resources do
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
