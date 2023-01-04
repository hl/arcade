defmodule ArcadeRegions do
  @moduledoc """
  The Region is responsible for ...
  """

  use Boundary, deps: [Arcade, ArcadeWorlds]

  alias Arcade.HordeRegistry
  alias ArcadeRegions.RegionDynamicSupervisor
  alias ArcadeRegions.RegionProcess

  def start_child(name, world_iid) when is_binary(name) and is_tuple(world_iid) do
    num = HordeRegistry.next_key(:region, name)
    iid = {:region, name, num}

    [iid: iid, name: name, world_iid: world_iid]
    |> RegionProcess.child_spec()
    |> RegionDynamicSupervisor.start_child()
  end
end
