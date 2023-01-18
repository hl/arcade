defmodule ArcadeWorlds.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias ArcadeWorlds.WorldSchema
  alias ArcadeWorlds.WorldState

  defstruct name: nil, map: nil, zones: MapSet.new()

  @type t :: %WorldState{
          name: ArcadeWorlds.name() | nil,
          map: String.t() | nil,
          zones: MapSet.t(ArcadeZones.name())
        }

  @spec set_map(t, String.t()) :: t
  def set_map(%WorldState{} = state, map) do
    %{state | map: map}
  end

  @spec get_map(t) :: String.t()
  def get_map(%WorldState{map: map}) do
    map
  end

  @spec save_state(t) :: WorldSchema.t() | no_return()
  def save_state(%WorldState{} = state) do
    map = Utils.struct_to_map(state)
    name = ProcessName.serialize(map.name)
    zones = Enum.map(get_zones(state), &ProcessName.serialize/1)
    attrs = %{map | name: name, zones: zones}
    schema = WorldSchema.get_by_name(state.name) || %WorldSchema{}

    WorldSchema.save!(schema, attrs)
  end

  @spec load_state(ArcadeWorlds.name(), Keyword.t()) :: t
  def load_state(name, args) when is_tuple(name) do
    attrs =
      case WorldSchema.get_by_name(name) do
        nil ->
          args

        world_schema ->
          world_schema
          |> Utils.struct_to_map()
          |> Map.merge(Map.new(args))
          |> Map.put(:zones, MapSet.new(world_schema.zones, &ProcessName.parse/1))
      end

    struct(WorldState, attrs)
  end

  @spec register_zone(t, ArcadeZones.name()) :: t
  def register_zone(%WorldState{} = state, zone_name) when is_tuple(zone_name) do
    case state do
      %{zones: []} -> %{state | zones: MapSet.new([zone_name])}
      %{zones: zones} -> %{state | zones: MapSet.put(zones, zone_name)}
    end
  end

  @spec unregister_zone(t, ArcadeZones.name()) :: t
  def unregister_zone(%WorldState{} = state, zone_name) when is_tuple(zone_name) do
    %{state | zones: MapSet.delete(state.zones, zone_name)}
  end

  @spec get_zones(t) :: [ArcadeZones.name()]
  def get_zones(%WorldState{zones: zones}) do
    MapSet.to_list(zones)
  end
end
