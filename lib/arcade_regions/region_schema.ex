defmodule ArcadeRegions.RegionSchema do
  @moduledoc """
  The Region schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.Repo
  alias ArcadeRegions.RegionSchema

  import Ecto.Changeset

  schema "regions" do
    field :name
    field :world_name
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/name world_name/a)
    |> validate_required(~w/name world_name/a)
    |> Repo.insert_or_update!()
  end

  def get_by_world_name(world_name) do
    Repo.get_by(RegionSchema, world_name: world_name)
  end

  def get_by_name(name) do
    Repo.get_by(RegionSchema, name: name)
  end

  def to_map(region_schema) do
    Map.from_struct(region_schema)
  end
end
