defmodule ArcadeWorlds do
  @moduledoc """
  The ArcadeWorlds is responsible for ...
  """

  use Boundary, deps: [Arcade]

  alias ArcadeWorlds.WorldDynamicSupervisor
  alias ArcadeWorlds.WorldProcess

  @type name :: {:world, String.t()}

  @registry_type :world

  @spec start_child(String.t(), Keyword.t()) :: DynamicSupervisor.on_start_child()
  def start_child(name, attrs \\ []) when is_binary(name) do
    attrs
    |> Keyword.put(:name, {@registry_type, name})
    |> WorldProcess.child_spec()
    |> WorldDynamicSupervisor.start_child()
  end

  @spec set_map(name, String.t()) :: :ok
  def set_map(name, map) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.set_map(map)
  end

  @spec register_island(name, ArcadeIslands.name()) :: :ok
  def register_island(name, island_name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.register_island(island_name)
  end

  @spec unregister_island(name, ArcadeIslands.name()) :: :ok
  def unregister_island(name, island_name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.unregister_island(island_name)
  end

  @spec get_map(name) :: String.t() | nil
  def get_map(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.get_map()
  end

  @spec get_islands(name) :: [ArcadeIslands.name()]
  def get_islands(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.get_islands()
  end
end
