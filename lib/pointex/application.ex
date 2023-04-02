defmodule Pointex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PointexWeb.Telemetry,
      # Start the Ecto repository
      Pointex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pointex.PubSub},
      # Start Finch
      {Finch, name: Pointex.Finch},
      # Start the Endpoint (http/https)
      PointexWeb.Endpoint,
      Pointex.Commanded.Application,

      # projectors
      {Pointex.Model.ReadModels.MyWatchParties.Projector, application: Pointex.Commanded.Application, name: "my_watch_parties"},
      {Pointex.Model.ReadModels.Participants.Projector, application: Pointex.Commanded.Application, name: "participants"}

      # Start a worker by calling: Pointex.Worker.start_link(arg)
      # {Pointex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pointex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PointexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
