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
  horde: [
    ArcadeWorlds.WorldDynamicSupervisor,
    ArcadeRegions.RegionDynamicSupervisor
  ]

import_config "#{config_env()}.exs"
