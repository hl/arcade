defmodule ArcadeWorlds.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias ArcadeWorlds.WorldSchema
  alias ArcadeWorlds.WorldState

  defstruct iid: nil, name: nil, map: nil, regions: []

  def set_map(%WorldState{} = state, map) do
    %{state | map: map}
  end

  def get_map(%WorldState{map: map}) do
    map
  end

  def save_state(%WorldState{} = state) do
    params = to_map(state)
    struct = WorldSchema.get_by_iid(state.iid) || %WorldSchema{}

    WorldSchema.save(struct, params)
  end

  def load_state(iid) do
    case WorldSchema.get_by_iid(iid) do
      nil -> %WorldState{iid: iid}
      world_schema -> struct!(WorldState, WorldSchema.to_map(world_schema))
    end
  end

  def to_map(%WorldState{} = world_state) do
    world_state
    |> Map.from_struct()
    |> serialize_regions()
  end

  def serialize_regions(map) do
    regions =
      case map do
        %{regions: [] = regions} -> regions
        %{regions: regions} -> MapSet.to_list(regions)
      end

    %{map | regions: regions}
  end

  def register_region(%WorldState{} = state, region_iid) do
    case state do
      %{regions: []} -> %{state | regions: MapSet.new([region_iid])}
      %{regions: regions} -> %{state | regions: MapSet.put(regions, region_iid)}
    end
  end

  def unregister_region(%WorldState{} = state, region_iid) do
    %{state | regions: MapSet.delete(state.regions, region_iid)}
  end

  def get_regions(%WorldState{} = state) do
    case state do
      %{regions: [] = regions} -> regions
      %{regions: regions} -> MapSet.to_list(regions)
    end
  end
end
