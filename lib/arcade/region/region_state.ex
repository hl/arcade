defmodule Arcade.RegionState do
  @moduledoc """
  The Region state is responsible for ...
  """

  alias Arcade.RegionSchema
  alias Arcade.RegionState

  defstruct [:name, :world_name]

  def set_name(%RegionState{} = state, name) do
    %{state | name: name}
  end

  def get_name(%RegionState{name: name}) do
    name
  end

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

  def to_map(%RegionState{} = region_state) do
    Map.from_struct(region_state)
  end
end
