defmodule PointexWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides

  # configure your UI overrides here

  # First argument to `override` is the component name you are overriding.
  # The body contains any number of configurations you wish to override
  # Below are some examples

  # For a complete reference, see https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html

  override AshAuthentication.Phoenix.Components.Banner do
    set :image_url, "https://upload.wikimedia.org/wikipedia/en/e/e1/Eurovision_Song_Contest.svg"
    set :image_class, "w-[400px]"
    set :text, "EuroPoints"
    set :root_class, "flex flex-col gap-4 items-center"
  end

  # override AshAuthentication.Phoenix.Components.SignIn do
  #  set :show_banner, false
  # end
end
