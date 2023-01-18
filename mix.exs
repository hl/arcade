defmodule Arcade.MixProject do
  use Mix.Project

  def project do
    [
      app: :arcade,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      compilers: [:boundary] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ArcadeApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:horde, "~> 0.8.7"},
      {:ecto_sql, "~> 3.0"},
      {:ecto_sqlite3, "~> 0.9.0"},
      {:puid, "~> 2.0"},
      {:boundary, "~> 0.9.4", runtime: false},
      {:credo, "~> 1.6", runtime: false, only: [:dev, :test]},
      {:dialyxir, "~> 1.2", runtime: false}
    ]
  end
end
