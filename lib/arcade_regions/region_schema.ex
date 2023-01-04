defmodule ArcadeRegions.RegionSchema do
  @moduledoc """
  The Region schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.IID
  alias Arcade.Repo
  alias ArcadeRegions.RegionSchema

  import Ecto.Changeset

  schema "regions" do
    field :iid
    field :name
    field :world_iid
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/iid name world_iid/a)
    |> validate_required(~w/iid name world_iid/a)
    |> Repo.insert_or_update!()
  end

  def get_by_iid(iid) when is_tuple(iid) do
    iid |> IID.serialize() |> get_by_iid()
  end

  def get_by_iid(iid) when is_binary(iid) do
    Repo.get_by(RegionSchema, iid: iid)
  end

  def to_map(region_schema) do
    map = Map.from_struct(region_schema)
    %{map | iid: IID.parse(map.iid)}
  end
end
