defmodule Arcade.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.Repo
  alias Arcade.WorldSchema

  import Ecto.Changeset

  schema "worlds" do
    field :name
    field :map
    timestamps()
  end

  def save(struct, params) do
    struct
    |> cast(params, ~w/name map/a)
    |> validate_required(~w/name map/a)
    |> Repo.insert_or_update!()
  end

  def get_by_name(name) do
    Repo.get_by(WorldSchema, name: name)
  end

  def to_map(world_schema) do
    Map.from_struct(world_schema)
  end
end
