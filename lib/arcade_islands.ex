defmodule ArcadeIslands do
  @moduledoc """
  The ArcadeIslands is responsible for ...
  """

  use Boundary, deps: [Arcade, ArcadeWorlds]

  alias ArcadeIslands.IslandDynamicSupervisor
  alias ArcadeIslands.IslandProcess
  alias ArcadeIslands.IslandState

  @type name :: {:island, String.t(), non_neg_integer(), non_neg_integer()}
  @type x_coordinate :: non_neg_integer()
  @type y_coordinate :: non_neg_integer()

  @registry_type :island

  @spec start_child(String.t(), ArcadeWorlds.name(), x_coordinate, y_coordinate, Keyword.t()) ::
          DynamicSupervisor.on_start_child()
  def start_child(name, world_name, x, y, attrs \\ [])
      when is_binary(name) and is_tuple(world_name) and is_integer(x) and is_integer(y) do
    name = "#{elem(world_name, 1)}_#{name}"

    attrs
    |> Keyword.put(:name, {@registry_type, name, x, y})
    |> Keyword.put(:world_name, world_name)
    |> Keyword.put(:coordinates, %{x: x, y: y})
    |> IslandProcess.child_spec()
    |> IslandDynamicSupervisor.start_child()
  end

  @spec get_coordinates(name) :: IslandState.coordinates()
  def get_coordinates(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> IslandProcess.get_coordinates()
  end
end
