defmodule Arcade.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias Arcade.WorldSchema
  alias Arcade.WorldState

  defstruct name: nil,
            map: nil,
            regions: []

  def set_name(%WorldState{} = state, name) do
    %{state | name: name}
  end

  def get_name(%WorldState{name: name}) do
    name
  end

  def set_map(%WorldState{} = state, map) do
    %{state | map: map}
  end

  def get_map(%WorldState{map: map}) do
    map
  end

  def save_state(%WorldState{} = state) do
    params = to_map(state)
    struct = WorldSchema.get_by_name(state.name) || %WorldSchema{}

    WorldSchema.save(struct, params)
  end

  def load_state(name) do
    case WorldSchema.get_by_name(name) do
      nil -> %WorldState{name: name}
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

  def register_region(%WorldState{} = state, region_name) do
    case state do
      %{regions: []} -> %{state | regions: MapSet.new([region_name])}
      %{regions: regions} -> %{state | regions: MapSet.put(regions, region_name)}
    end
  end

  def unregister_region(%WorldState{} = state, region_name) do
    %{state | regions: MapSet.delete(state.regions, region_name)}
  end

  def get_regions(%WorldState{} = state) do
    case state do
      %{regions: [] = regions} -> regions
      %{regions: regions} -> MapSet.to_list(regions)
    end
  end
end
