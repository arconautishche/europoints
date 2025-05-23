defmodule PointexWeb.Router do
  use PointexWeb, :router
  import PointexWeb.UserAuth
  import AshAdmin.Router

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

    scope "/" do
      pipe_through :try_prolong_user_session

      live_session :logged_in,
        on_mount: [
          PointexWeb.UserAuth,
          {PointexWeb.UserAuth, :ensure_logged_in}
        ] do
        live "/", Home
        live "/login_instructions", Home, :show_login_instructions, as: :home
        live "/felicitoshka", UserList

        scope "/wp" do
          live "/new", WatchParty.New
          live "/join", WatchParty.Join
          live "/join/:id", WatchParty.Join
          live "/:id/viewing", WatchParty.Viewing
          live "/:id/voting", WatchParty.Voting
          live "/:id/results", WatchParty.Results, :wp_totals, as: :action
          live "/:id/results/predictions", WatchParty.Results, :predictions, as: :action
          live "/:id/real-results", WatchParty.RealResults
          live "/:id", WatchParty.Overview
          live "/:id/admin", WatchParty.Admin
        end

        # Season overview route
        live "/season/:year", SeasonOverview
        live "/season/:year/songs", SeasonSongs

        # Specific routes for each type
        live "/show/:year/final", ShowFinal
        live "/show/:year/:kind", ShowSemiFinal, :semi_final

        # Redirect old routes to the new season overview
        live "/show/:year/:kind/overview", SeasonOverview
      end
    end
  end

  scope "/admin" do
    pipe_through :browser

    ash_admin("/")
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
