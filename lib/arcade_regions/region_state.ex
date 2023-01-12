defmodule ArcadeRegions.RegionState do
  @moduledoc """
  The Region state is responsible for ...
  """

  alias Arcade.ProcessName
  alias ArcadeRegions.RegionSchema
  alias ArcadeRegions.RegionState

  defstruct [:name, :world_name, :coordinates]

  def save_state(%RegionState{} = state) do
    map = Map.from_struct(state)

    attrs = %{
      map
      | name: ProcessName.serialize(map.name),
        world_name: ProcessName.serialize(map.world_name)
    }

    struct = RegionSchema.get_by_name(state.name) || %RegionSchema{}

    RegionSchema.save(struct, attrs)
  end

  def load_state(name, args) when is_tuple(name) do
    attrs =
      case RegionSchema.get_by_name(name) do
        nil ->
          args

        region_schema ->
          map = Map.from_struct(region_schema)

          %{
            map
            | name: ProcessName.parse(map.name),
              world_name: ProcessName.parse(map.world_name)
          }
      end

    struct!(RegionState, attrs)
  end

  def get_coordinates(%RegionState{coordinates: coordinates}) do
    coordinates
  end
end
