import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pointex, Pointex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pointex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pointex, PointexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+W9GcNzwbHX2VWS5WQiy0A1r0PxULulR0CjjuBQ12G+8Du+YCKt3ABPME3lYXBPs",
  server: false

config :pointex, Pointex.Commanded.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "pointex_eventstore_test",
  hostname: "localhost",
  pool_size: 10

# In test we don't send emails.
config :pointex, Pointex.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
