defmodule Arcade.Zones.ZoneSchema do
  @moduledoc """
  The Zone schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias Arcade.Zones.ZoneSchema

  import Ecto.Changeset

  @type t :: %ZoneSchema{
          id: non_neg_integer() | nil,
          name: String.t() | nil,
          world_name: String.t() | nil,
          coordinates: Ecto.Schema.embeds_one(Arcade.Zones.ZoneCoordinatesSchema.t()),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "zones" do
    field :name
    field :world_name

    embeds_one :coordinates, Arcade.Zones.ZoneCoordinatesSchema, on_replace: :delete

    timestamps()
  end

  @spec save!(t, map()) :: t | no_return()
  def save!(%ZoneSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name name world_name/a)
    |> cast_embed(:coordinates)
    |> validate_required(~w/name name world_name/a)
    |> Repo.insert_or_update!()
  end

  @spec get_by_name(Arcade.Zones.name()) :: t | nil
  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  @spec get_by_name(String.t()) :: t | nil
  def get_by_name(name) when is_binary(name) do
    Repo.get_by(ZoneSchema, name: name)
  end
end
