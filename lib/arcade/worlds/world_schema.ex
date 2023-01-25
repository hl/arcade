defmodule Arcade.Worlds.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """

  use Arcade.Schema, repo: Arcade.Repo

  @opaque t :: %WorldSchema{
            id: non_neg_integer() | nil,
            name: Arcade.Worlds.name() | nil,
            map: String.t() | nil,
            zones: [Arcade.Zones.name()],
            inserted_at: NaiveDateTime.t() | nil,
            updated_at: NaiveDateTime.t() | nil
          }

  schema "worlds" do
    field :name
    field :map
    field :zones, {:array, :string}
    timestamps()
  end

  @spec changeset(t, map()) :: Ecto.Changeset.t(t())
  def changeset(%WorldSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name map zones/a)
    |> validate_required(~w/name/a)
  end
end
