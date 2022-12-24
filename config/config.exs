import Config

config :libcluster,
  debug: false,
  topologies: [
    arcade_gossip: [
      strategy: Cluster.Strategy.Gossip
    ]
  ]

config :arcade,
  ecto_repos: [Arcade.Repo],
  supervisors: [Arcade.WorldSupervisor, Arcade.RegionSupervisor]

import_config "#{config_env()}.exs"
