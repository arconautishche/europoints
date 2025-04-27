defmodule PointexWeb.Router do
  use PointexWeb, :router
  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers
  import PointexWeb.UserAuth
  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PointexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :set_actor, :user
  end

  scope "/", PointexWeb do
    pipe_through :browser

    scope "/" do
      pipe_through :try_prolong_user_session

      ash_authentication_live_session :logged_in,
        on_mount: [
          {PointexWeb.LiveUserAuth, :current_account},
          {PointexWeb.LiveUserAuth, :account_required},
          {PointexWeb.LiveUserAuth, :account_with_name_required}
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

      ash_authentication_live_session :account_setup_incomplete,
        on_mount: [{PointexWeb.LiveUserAuth, :current_account}, {PointexWeb.LiveUserAuth, :account_required}] do
        live "/account/name", ChangeAccountName
      end
    end

    auth_routes AuthController, Pointex.Accounts.Account, path: "/auth"
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{PointexWeb.LiveUserAuth, :no_account}],
                  overrides: [PointexWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]

    # Remove this if you do not want to use the reset password feature
    reset_route auth_routes_prefix: "/auth", overrides: [PointexWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
  end

  scope "/", PointexWeb do
    pipe_through :browser

    ash_authentication_live_session :authenticated_routes do
      # in each liveview, add one of the following at the top of the module:
      #
      # If an authenticated user must be present:
      # on_mount {PointexWeb.LiveUserAuth, :live_user_required}
      #
      # If an authenticated user *may* be present:
      # on_mount {PointexWeb.LiveUserAuth, :live_user_optional}
      #
      # If an authenticated user must *not* be present:
      # on_mount {PointexWeb.LiveUserAuth, :live_no_user}
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
