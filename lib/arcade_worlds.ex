defmodule ArcadeWorlds do
  @moduledoc """
  The World is responsible for ...
  """

  use Boundary, deps: [Arcade]

  alias Arcade.HordeRegistry
  alias ArcadeWorlds.WorldDynamicSupervisor
  alias ArcadeWorlds.WorldProcess

  @registry_type :world

  def start_child(name) when is_binary(name) do
    num = HordeRegistry.next_key(@registry_type, name)
    iid = {@registry_type, name, num}

    [iid: iid, name: name]
    |> WorldProcess.child_spec()
    |> WorldDynamicSupervisor.start_child()
  end

  def set_map(iid, map) do
    iid
    |> HordeRegistry.whereis_name()
    |> WorldProcess.set_map(map)
  end

  def get_map(iid) do
    iid
    |> HordeRegistry.whereis_name()
    |> WorldProcess.get_map()
  end

  def register_region(iid, region_iid) do
    iid
    |> HordeRegistry.whereis_name()
    |> WorldProcess.register_region(region_iid)
  end

  def unregister_region(iid, region_iid) do
    iid
    |> HordeRegistry.whereis_name()
    |> WorldProcess.unregister_region(region_iid)
  end

  def get_regions(iid) do
    iid
    |> HordeRegistry.whereis_name()
    |> WorldProcess.get_regions()
  end
end
