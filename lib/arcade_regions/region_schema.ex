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

    embeds_one :coordinates, ArcadeRegions.CoordinateSchema, on_replace: :delete

    timestamps()
  end

  def save(%RegionSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name name world_name/a)
    |> cast_embed(:coordinates)
    |> validate_required(~w/name name world_name/a)
    |> Repo.insert_or_update!()
  end

  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(RegionSchema, name: name)
  end
end
