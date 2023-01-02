defmodule ArcadeRegions do
  @moduledoc """
  The Region is responsible for ...
  """

  use Boundary, deps: [Arcade, ArcadeWorlds]

  alias ArcadeRegions.RegionDynamicSupervisor
  alias ArcadeRegions.RegionProcess

  def start_child(name, world_name) when is_binary(name) and is_binary(world_name) do
    [name: name, world_name: world_name]
    |> RegionProcess.child_spec()
    |> RegionDynamicSupervisor.start_child()
  end
end
