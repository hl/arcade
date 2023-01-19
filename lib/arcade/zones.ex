defmodule Arcade.Zones do
  @moduledoc """
  The Arcade.Zones is responsible for ...
  """

  use Boundary, deps: [Arcade, Arcade.Worlds], top_level?: true

  alias Arcade.Worlds
  alias Arcade.Zones.ZoneDynamicSupervisor
  alias Arcade.Zones.ZoneName
  alias Arcade.Zones.ZoneProcess
  alias Arcade.Zones.ZoneState

  @type name ::
          {
            :zone,
            world_name :: String.t(),
            zone_name :: String.t(),
            x :: integer(),
            y :: integer()
          }
  @type x_coordinate :: non_neg_integer()
  @type y_coordinate :: non_neg_integer()

  @registry_type :zone

  @spec start_child(String.t(), Worlds.name(), x_coordinate, y_coordinate, Keyword.t()) ::
          DynamicSupervisor.on_start_child()
  def start_child(name, world_name, x, y, attrs \\ [])
      when is_binary(name) and is_tuple(world_name) and is_integer(x) and is_integer(y) do
    attrs
    |> Keyword.put(:name, {@registry_type, elem(world_name, 1), name, x, y})
    |> Keyword.put(:world_name, world_name)
    |> Keyword.put(:coordinates, %{x: x, y: y})
    |> ZoneProcess.child_spec()
    |> ZoneDynamicSupervisor.start_child()
  end

  @spec get_coordinates(name) :: ZoneState.coordinates()
  def get_coordinates(name) do
    name
    |> Arcade.Registry.whereis_name()
    |> ZoneProcess.get_coordinates()
  end

  @spec generate_zones(Worlds.name()) :: :ok
  def generate_zones(world_name) do
    size = Application.get_env(:arcade, :zone_size)

    for x <- 0..(size - 1), y <- 0..(size - 1) do
      start_child(ZoneName.generate(), world_name, x, y)
    end

    :ok
  end
end
