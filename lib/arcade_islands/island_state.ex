defmodule ArcadeIslands.IslandState do
  @moduledoc """
  The Island state is responsible for ...
  """

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias ArcadeIslands.IslandSchema
  alias ArcadeIslands.IslandState
  alias ArcadeWorlds

  defstruct [:name, :world_name, :coordinates]

  @type t :: %__MODULE__{
          name: ArcadeIslands.name() | nil,
          world_name: ArcadeWorlds.name() | nil,
          coordinates: coordinates
        }

  @type coordinates :: %{
          x: non_neg_integer() | nil,
          y: non_neg_integer() | nil
        }

  @spec save_state(t) :: IslandSchema.t() | no_return()
  def save_state(%IslandState{} = state) do
    map = Utils.struct_to_map(state)

    attrs = %{
      map
      | name: ProcessName.serialize(map.name),
        world_name: ProcessName.serialize(map.world_name)
    }

    struct = IslandSchema.get_by_name(state.name) || %IslandSchema{}

    IslandSchema.save!(struct, attrs)
  end

  @spec load_state(ArcadeIslands.name(), Keyword.t()) :: t
  def load_state(name, args) when is_tuple(name) do
    attrs =
      case IslandSchema.get_by_name(name) do
        nil ->
          args

        island_schema ->
          island_schema
          |> Utils.struct_to_map()
          |> Map.merge(Map.new(args))
      end

    struct(IslandState, attrs)
  end

  @spec get_coordinates(IslandState.t()) :: coordinates
  def get_coordinates(%IslandState{coordinates: coordinates}) do
    coordinates
  end
end
