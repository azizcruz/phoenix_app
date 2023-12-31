defmodule LiveViewTodos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveViewTodosWeb.Telemetry,
      # Start the Ecto repository
      LiveViewTodos.Repo,
      # Start Finch
      {Finch, name: LiveViewTodos.Finch},
      {Phoenix.PubSub, name: LiveViewTodos.PubSub, adapter: Phoenix.PubSub.PG2},
      # Start the Endpoint (http/https)
      LiveViewTodosWeb.Endpoint
      # Start a worker by calling: LiveViewTodos.Worker.start_link(arg)
      # {LiveViewTodos.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewTodos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewTodosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
