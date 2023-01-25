defmodule Arcade.Zones.ZoneState do
  @moduledoc """
  The Zone state is responsible for ...
  """

  alias Arcade.ProcessName
  alias Arcade.Utils
  alias Arcade.Zones.ZoneSchema
  alias Arcade.Zones.ZoneState

  defstruct [:name, :world_name, :coordinates]

  @opaque t :: %__MODULE__{
            name: Arcade.Zones.name(),
            world_name: Arcade.Worlds.name(),
            coordinates: coordinates
          }

  @opaque coordinates :: %{
            x: non_neg_integer() | nil,
            y: non_neg_integer() | nil
          }

  @spec get_name(t) :: Arcade.Zones.name()
  def get_name(%ZoneState{name: name}) do
    name
  end

  @spec get_world_name(t) :: Arcade.Worlds.name()
  def get_world_name(%ZoneState{world_name: world_name}) do
    world_name
  end

  @spec save_state(t) :: ZoneSchema.t() | no_return()
  def save_state(%ZoneState{} = state) do
    map = Utils.struct_to_map(state)

    attrs = %{
      map
      | name: ProcessName.serialize(map.name),
        world_name: ProcessName.serialize(map.world_name)
    }

    struct =
      with nil <- ZoneSchema.get_by_name(state.name) do
        ZoneSchema.new()
      end

    ZoneSchema.save!(struct, attrs)
  end

  @spec load_state(Arcade.Zones.name(), Keyword.t()) :: t
  def load_state(name, args) when is_tuple(name) do
    attrs =
      case ZoneSchema.get_by_name(name) do
        nil ->
          args

        zone_schema ->
          zone_schema
          |> ZoneSchema.to_map()
          |> Map.merge(Map.new(args))
      end

    struct(ZoneState, attrs)
  end

  @spec get_coordinates(ZoneState.t()) :: coordinates
  def get_coordinates(%ZoneState{coordinates: coordinates}) do
    coordinates
  end
end
