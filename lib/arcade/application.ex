defmodule Arcade.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: Arcade.ClusterSupervisor]]},
      Arcade.Registry,
      Arcade.WorldSupervisor,
      Arcade.NodeListener
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arcade.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      arcade_gossip: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end
