defmodule Pointex.Repo do
  use AshPostgres.Repo, otp_app: :pointex

  def installed_extensions do
    ["ash-functions"]
  end
end
