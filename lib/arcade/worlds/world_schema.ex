defmodule Arcade.Worlds.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """
  use Ecto.Schema
  use TypedEctoSchema

  import Ecto.Changeset

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias Arcade.Worlds.WorldSchema

  typed_schema "worlds", opaque: true do
    field :name, :string
    field :map, :string
    field :zones, {:array, :string}
    timestamps()
  end

  @spec new(Keyword.t() | map()) :: t()
  def new(attrs \\ []) do
    struct(WorldSchema, attrs)
  end

  @spec to_map(t) :: map()
  def to_map(struct) do
    Arcade.Utils.struct_to_map(struct)
  end

  @spec save!(t, map()) :: t | no_return()
  def save!(struct, attrs) do
    struct
    |> changeset(attrs)
    |> Repo.insert_or_update!()
  end

  @spec changeset(t, map()) :: Ecto.Changeset.t(t())
  def changeset(%WorldSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name map zones/a)
    |> validate_required(~w/name/a)
  end

  @spec get_by_name(tuple() | String.t()) :: t | nil
  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(__MODULE__, name: name)
  end

  @spec get_zones(t) :: MapSet.t([Arcade.Zones.name()])
  def get_zones(%WorldSchema{zones: zones}) do
    zones
  end
end
