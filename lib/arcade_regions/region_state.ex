defmodule ArcadeRegions.RegionState do
  @moduledoc """
  The Region state is responsible for ...
  """

  alias Arcade.IID
  alias ArcadeRegions.RegionSchema
  alias ArcadeRegions.RegionState

  defstruct [:iid, :name, :world_iid]

  def save_state(%RegionState{} = state) do
    params = to_map(state)
    struct = RegionSchema.get_by_iid(state.iid) || %RegionSchema{}

    RegionSchema.save(struct, params)
  end

  def load_state(iid, args) do
    fields =
      case RegionSchema.get_by_iid(iid) do
        nil -> args
        region_schema -> RegionSchema.to_map(region_schema)
      end

    struct!(RegionState, fields)
  end

  def to_map(%RegionState{} = region_state) do
    map = Map.from_struct(region_state)
    %{map | iid: IID.serialize(map.iid), world_iid: IID.serialize(map.world_iid)}
  end
end
