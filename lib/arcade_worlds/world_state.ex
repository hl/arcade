defmodule ArcadeWorlds.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias ArcadeWorlds.WorldSchema
  alias ArcadeWorlds.WorldState

  defstruct name: nil, map: nil, regions: []

  def set_map(%WorldState{} = state, map) do
    %{state | map: map}
  end

  def get_map(%WorldState{map: map}) do
    map
  end

  def save_state(%WorldState{} = state) do
    map = Utils.struct_to_map(state)
    name = ProcessName.serialize(map.name)
    regions = get_regions(state)
    attrs = %{map | name: name, regions: regions}
    schema = WorldSchema.get_by_name(state.name) || %WorldSchema{}

    WorldSchema.save(schema, attrs)
  end

  def load_state(name, args) when is_tuple(name) do
    attrs =
      case WorldSchema.get_by_name(name) do
        nil ->
          args

        world_schema ->
          %{
            Utils.struct_to_map(world_schema)
            | name: ProcessName.parse(world_schema.name),
              regions: MapSet.new(world_schema.regions, &ProcessName.parse/1)
          }
      end

    struct(WorldState, attrs)
  end

  def register_region(%WorldState{} = state, region_name) when is_tuple(region_name) do
    case state do
      %{regions: []} -> %{state | regions: MapSet.new([region_name])}
      %{regions: regions} -> %{state | regions: MapSet.put(regions, region_name)}
    end
  end

  def unregister_region(%WorldState{} = state, region_name) when is_tuple(region_name) do
    %{state | regions: MapSet.delete(state.regions, region_name)}
  end

  def get_regions(%WorldState{} = state) do
    case state do
      %{regions: [] = regions} -> regions
      %{regions: regions} -> MapSet.to_list(regions)
    end
  end
end
