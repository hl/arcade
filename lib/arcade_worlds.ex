defmodule ArcadeWorlds do
  @moduledoc """
  The ArcadeWorlds is responsible for ...
  """

  use Boundary, deps: [Arcade]

  alias ArcadeWorlds.WorldDynamicSupervisor
  alias ArcadeWorlds.WorldProcess

  @registry_type :world

  def start_child(name) when is_binary(name) do
    index = Arcade.Registry.next_index(@registry_type, name)
    name = {@registry_type, name, index}

    [name: name]
    |> WorldProcess.child_spec()
    |> WorldDynamicSupervisor.start_child()
  end

  def set_map(name, map) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.set_map(map)
  end

  def get_map(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.get_map()
  end

  def register_region(name, region_name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.register_region(region_name)
  end

  def unregister_region(name, region_name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.unregister_region(region_name)
  end

  def get_regions(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> WorldProcess.get_regions()
  end
end
