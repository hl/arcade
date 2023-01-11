defmodule ArcadeRegions.RegionSchema do
  @moduledoc """
  The Region schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias ArcadeRegions.RegionSchema

  import Ecto.Changeset

  schema "regions" do
    field :name
    field :world_name
    field :coordinates, :decimal
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/name name world_name coordinates/a)
    |> validate_required(~w/name name world_name coordinates/a)
    |> Repo.insert_or_update!()
  end

  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(RegionSchema, name: name)
  end

  def to_map(region_schema) do
    map = Map.from_struct(region_schema)
    %{map | name: ProcessName.parse(map.name)}
  end
end