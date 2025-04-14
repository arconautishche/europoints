defmodule Pointex.Accounts do
  use Ash.Domain,
    otp_app: :pointex

  resources do
    resource Pointex.Accounts.Token

    resource Pointex.Accounts.Account do
      define :register_with_magic_link, action: :register, args: [:name, :email]
    end
  end
end
