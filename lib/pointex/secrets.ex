defmodule Pointex.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Pointex.Accounts.Account,
        _opts,
        _context
      ) do
    Application.fetch_env(:pointex, :token_signing_secret)
  end
end
