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
  supervisors: [
    ArcadeWorlds.WorldSupervisor,
    ArcadeRegions.RegionSupervisor
  ]

import_config "#{config_env()}.exs"
