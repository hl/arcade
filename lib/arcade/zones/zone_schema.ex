defmodule Arcade.Zones.ZoneSchema do
  @moduledoc """
  The Zone schema is responsible for ...
  """
  use Ecto.Schema
  use TypedEctoSchema

  import Ecto.Changeset

  alias Arcade.Repo
  alias Arcade.Zones.ZoneSchema

  typed_schema "zones" do
    field :name, :string
    field :world_name, :string

    embeds_one :coordinates, Arcade.Zones.ZoneCoordinatesSchema, on_replace: :delete

    timestamps()
  end

  @spec new(map()) :: t()
  def new(attrs \\ %{}) do
    struct(ZoneSchema, attrs)
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
  def changeset(%ZoneSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name name world_name/a)
    |> cast_embed(:coordinates)
    |> validate_required(~w/name name world_name/a)
  end

  @spec get_by_name(tuple() | String.t()) :: t | nil
  def get_by_name(name) when is_tuple(name) do
    name |> Arcade.ProcessName.serialize() |> get_by_name()
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(__MODULE__, name: name)
  end
end
