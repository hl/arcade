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
    Arcade.Worlds.WorldDynamicSupervisor,
    Arcade.Zones.ZoneDynamicSupervisor
  ],
  zone_size: 5

import_config "#{config_env()}.exs"
