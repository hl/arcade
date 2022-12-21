defmodule Arcade.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias Arcade.WorldSchema
  alias Arcade.WorldState

  defstruct [:name, :map]

  def new do
    %WorldState{}
  end

  def new(nil) do
    new()
  end

  def new(%WorldSchema{} = world_schema) do
    new(WorldSchema.to_map(world_schema))
  end

  def new(args) when is_map(args) do
    struct!(WorldState, args)
  end

  def set_name(state, name) do
    %{state | name: name}
  end

  def get_name(%WorldState{name: name}) do
    name
  end

  def set_map(state, map) do
    %{state | map: map}
  end

  def get_map(%WorldState{map: map}) do
    map
  end

  def save_state(state) do
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

  def to_map(world_state) do
    Map.from_struct(world_state)
  end
end
