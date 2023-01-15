defmodule ArcadeIslands.IslandSchema do
  @moduledoc """
  The Island schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias ArcadeIslands.IslandSchema

  import Ecto.Changeset

  @type t :: %IslandSchema{
          id: non_neg_integer() | nil,
          name: String.t() | nil,
          world_name: String.t() | nil,
          coordinates: Ecto.Schema.embeds_one(ArcadeIslands.CoordinatesSchema.t()),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "islands" do
    field :name
    field :world_name

    embeds_one :coordinates, ArcadeIslands.CoordinatesSchema, on_replace: :delete

    timestamps()
  end

  @spec save!(t, map()) :: t | no_return()
  def save!(%IslandSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name name world_name/a)
    |> cast_embed(:coordinates)
    |> validate_required(~w/name name world_name/a)
    |> Repo.insert_or_update!()
  end

  @spec get_by_name(ArcadeIslands.name()) :: t | nil
  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  @spec get_by_name(String.t()) :: t | nil
  def get_by_name(name) when is_binary(name) do
    Repo.get_by(IslandSchema, name: name)
  end
end
