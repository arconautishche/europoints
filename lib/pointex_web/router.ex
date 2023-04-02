defmodule PointexWeb.Router do
  use PointexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PointexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PointexWeb do
    pipe_through :browser

    post "/register", LoginController, :register
    post "/login", LoginController, :login
    get "/logout", LoginController, :logout

    live_session :default, on_mount: PointexWeb.UserAuth do
      live "/register", Register
      live "/login", Login
    end

    live_session :logged_in,
      on_mount: [
        PointexWeb.UserAuth,
        {PointexWeb.UserAuth, :ensure_logged_in}
      ] do
      live "/", Home
      live "/wp/new", NewWatchParty
      live "/wp/:id/viewing", WatchParty.Viewing
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PointexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pointex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PointexWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
