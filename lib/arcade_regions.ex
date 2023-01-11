defmodule ArcadeRegions do
  @moduledoc """
  The ArcadeRegions is responsible for ...
  """

  use Boundary, deps: [Arcade, ArcadeWorlds]

  alias ArcadeRegions.RegionDynamicSupervisor
  alias ArcadeRegions.RegionProcess

  @registry_type :region

  def start_child(name, world_name, coordinates) when is_binary(name) and is_tuple(world_name) do
    name = "#{elem(world_name, 1)}_#{name}"
    index = Arcade.Registry.next_index(@registry_type, name)
    name = {@registry_type, name, index}
    coordinates = Decimal.from_float(coordinates)

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
