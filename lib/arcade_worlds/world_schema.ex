defmodule ArcadeWorlds.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias ArcadeWorlds.WorldSchema

  import Ecto.Changeset

  schema "worlds" do
    field :name
    field :map
    field :regions, {:array, :string}
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/name map regions/a)
    |> validate_required(~w/name/a)
    |> Repo.insert_or_update!()
  end

  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(WorldSchema, name: name)
  end

  def to_map(world_schema) do
    map = Map.from_struct(world_schema)
    %{map | name: ProcessName.serialize(map.name)}
  end
end
