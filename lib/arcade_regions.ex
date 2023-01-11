defmodule ArcadeRegions do
  @moduledoc """
  The ArcadeRegions is responsible for ...
  """

  use Boundary, deps: [Arcade, ArcadeWorlds]

  alias ArcadeRegions.RegionDynamicSupervisor
  alias ArcadeRegions.RegionProcess

  @registry_type :region

  def start_child(name, world_name, %Decimal{} = coordinates)
      when is_binary(name) and is_tuple(world_name) do
    name = "#{elem(world_name, 1)}_#{name}"
    name = {@registry_type, name, coordinates}

    [name: name, world_name: world_name, coordinates: coordinates]
    |> RegionProcess.child_spec()
    |> RegionDynamicSupervisor.start_child()
  end

  def get_coordinates(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> RegionProcess.get_coordinates()
  end
end
