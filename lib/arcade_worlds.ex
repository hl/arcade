defmodule ArcadeWorlds do
  @moduledoc """
  The World is responsible for ...
  """

  use Boundary, deps: [Arcade]

  alias Arcade.HordeRegistry
  alias ArcadeWorlds.WorldDynamicSupervisor
  alias ArcadeWorlds.WorldProcess

  def start_child(name) when is_binary(name) do
    [name: name]
    |> WorldProcess.child_spec()
    |> WorldDynamicSupervisor.start_child()
  end

  def set_map(name, map) do
    name
    |> HordeRegistry.whereis_name()
    |> WorldProcess.set_map(map)
  end

  def get_map(name) do
    name
    |> HordeRegistry.whereis_name()
    |> WorldProcess.get_map()
  end

  def register_region(name, region_name) do
    name
    |> HordeRegistry.whereis_name()
    |> WorldProcess.register_region(region_name)
  end

  def unregister_region(name, region_name) do
    name
    |> HordeRegistry.whereis_name()
    |> WorldProcess.unregister_region(region_name)
  end

  def get_regions(name) do
    name
    |> HordeRegistry.whereis_name()
    |> WorldProcess.get_regions()
  end
end
