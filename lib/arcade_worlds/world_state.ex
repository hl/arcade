defmodule ArcadeWorlds.WorldState do
  @moduledoc """
  The World state is responsible for ...
  """

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias ArcadeWorlds.WorldSchema
  alias ArcadeWorlds.WorldState

  defstruct name: nil, map: nil, islands: MapSet.new()

  @type t :: %WorldState{
          name: ArcadeWorlds.name() | nil,
          map: String.t() | nil,
          islands: MapSet.t(ArcadeIslands.name())
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
    islands = Enum.map(get_islands(state), &ProcessName.serialize/1)
    attrs = %{map | name: name, islands: islands}
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
          |> Map.put(:islands, MapSet.new(world_schema.islands, &ProcessName.parse/1))
      end

    struct(WorldState, attrs)
  end

  @spec register_island(t, ArcadeIslands.name()) :: t
  def register_island(%WorldState{} = state, island_name) when is_tuple(island_name) do
    case state do
      %{islands: []} -> %{state | islands: MapSet.new([island_name])}
      %{islands: islands} -> %{state | islands: MapSet.put(islands, island_name)}
    end
  end

  @spec unregister_island(t, ArcadeIslands.name()) :: t
  def unregister_island(%WorldState{} = state, island_name) when is_tuple(island_name) do
    %{state | islands: MapSet.delete(state.islands, island_name)}
  end

  @spec get_islands(t) :: [ArcadeIslands.name()]
  def get_islands(%WorldState{islands: islands}) do
    MapSet.to_list(islands)
  end
end
