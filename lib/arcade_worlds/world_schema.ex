defmodule ArcadeWorlds.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.IID
  alias Arcade.Repo
  alias ArcadeWorlds.WorldSchema

  import Ecto.Changeset

  schema "worlds" do
    field :iid
    field :name
    field :map
    field :regions, {:array, :string}
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/iid name map regions/a)
    |> validate_required(~w/iid name/a)
    |> Repo.insert_or_update!()
  end

  def get_by_iid(iid) when is_tuple(iid) do
    iid |> IID.serialize() |> get_by_iid()
  end

  def get_by_iid(iid) when is_binary(iid) do
    Repo.get_by(WorldSchema, iid: iid)
  end

  def to_map(world_schema) do
    map = Map.from_struct(world_schema)
    %{map | iid: IID.serialize(map.iid)}
  end
end
