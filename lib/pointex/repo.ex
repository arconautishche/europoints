defmodule Pointex.Repo do
  use Ecto.Repo,
    otp_app: :pointex,
    adapter: Ecto.Adapters.Postgres
end
