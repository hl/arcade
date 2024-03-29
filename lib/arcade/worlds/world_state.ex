defmodule Arcade.Worlds.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """
  use TypedStruct

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias Arcade.Worlds.WorldSchema
  alias Arcade.Worlds.WorldState

  typedstruct opaque: true do
    field :name, Arcade.Worlds.name()
    field :map, String.t()
    field :zones, MapSet.t(Arcade.Zones.name()), default: MapSet.new()
  end

  @spec save_state(t) :: WorldSchema.t() | no_return()
  def save_state(%WorldState{} = state) do
    map = Utils.struct_to_map(state)
    name = ProcessName.serialize(map.name)
    zones = Enum.map(get_zones(state), &ProcessName.serialize/1)
    attrs = %{map | name: name, zones: zones}

    schema =
      with nil <- WorldSchema.get_by_name(name) do
        WorldSchema.new()
      end

    WorldSchema.save!(schema, attrs)
  end

  @spec load_state(Arcade.Worlds.name(), Keyword.t()) :: t
  def load_state(name, args) when is_tuple(name) do
    attrs =
      case WorldSchema.get_by_name(name) do
        nil ->
          args

        world_schema ->
          zones = WorldSchema.get_zones(world_schema)

          world_schema
          |> WorldSchema.to_map()
          |> Map.merge(Map.new(args))
          |> Map.put(:zones, MapSet.new(zones, &ProcessName.parse/1))
      end

    struct(WorldState, attrs)
  end

  @spec register_zone(t, Arcade.Zones.name()) :: t
  def register_zone(%WorldState{zones: zones} = state, zone_name) when is_tuple(zone_name) do
    %{state | zones: MapSet.put(zones, zone_name)}
  end

  @spec unregister_zone(t, Arcade.Zones.name()) :: t
  def unregister_zone(%WorldState{} = state, zone_name) when is_tuple(zone_name) do
    %{state | zones: MapSet.delete(state.zones, zone_name)}
  end

  @spec get_map(t) :: String.t()
  def get_map(%WorldState{map: map}) do
    map
  end

  @spec set_map(t, String.t()) :: t
  def set_map(%WorldState{} = state, map) do
    %{state | map: map}
  end

  @spec get_zones(t) :: [Arcade.Zones.name()]
  def get_zones(%WorldState{zones: zones}) do
    zones
  end
end
