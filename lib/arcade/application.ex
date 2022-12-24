defmodule Arcade.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      List.flatten([
        {Cluster.Supervisor, [topologies(), [name: Arcade.ClusterSupervisor]]},
        Arcade.Repo,
        Arcade.Registry,
        supervisors(),
        Arcade.NodeListener
      ])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arcade.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def topologies do
    Application.get_env(:libcluster, :topologies)
  end

  def supervisors do
    Application.get_env(:arcade, :supervisors)
  end
end
