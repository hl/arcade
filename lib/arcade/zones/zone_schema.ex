defmodule Arcade.Zones.ZoneSchema do
  @moduledoc """
  The Zone schema is responsible for ...
  """

  use Arcade.Schema, repo: Arcade.Repo

  @opaque t :: %ZoneSchema{
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

  @spec changeset(t, map()) :: Ecto.Changeset.t(t())
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, ~w/name name world_name/a)
    |> cast_embed(:coordinates)
    |> validate_required(~w/name name world_name/a)
  end
end
