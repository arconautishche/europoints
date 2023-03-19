defmodule Pointex.Commanded.Application do
  use Commanded.Application,
    otp_app: :pointex,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Pointex.Commanded.EventStore
    ]
end
