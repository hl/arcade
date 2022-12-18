import Config

config :libcluster,
  debug: false

config :arcade,
  ecto_repos: [Arcade.Repo]

config :arcade, Arcade.Repo, database: "data/database.db"
