defmodule ArcadeRegions.RegionState do
  @moduledoc """
  The Region state is responsible for ...
  """

  alias Arcade.ProcessName
  alias ArcadeRegions.RegionSchema
  alias ArcadeRegions.RegionState

  defstruct [:name, :world_name, :coordinates]

  def save_state(%RegionState{} = state) do
    params = to_map(state)
    struct = RegionSchema.get_by_name(state.name) || %RegionSchema{}

    RegionSchema.save(struct, params)
  end

  def load_state(name, args) do
    fields =
      case RegionSchema.get_by_name(name) do
        nil -> args
        region_schema -> RegionSchema.to_map(region_schema)
      end

    struct!(RegionState, fields)
  end

  def get_coordinates(%RegionState{coordinates: coordinates}) do
    base = Decimal.round(coordinates, 0, :down)

    {Decimal.to_integer(base),
     Decimal.to_integer(
       Decimal.mult(
         Decimal.sub(coordinates, base),
         Decimal.new(10)
       )
     )}
  end

  def to_map(%RegionState{} = region_state) do
    map = Map.from_struct(region_state)

    %{
      map
      | name: ProcessName.serialize(map.name),
        world_name: ProcessName.serialize(map.world_name)
    }
  end
end
