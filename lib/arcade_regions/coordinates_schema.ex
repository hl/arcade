defmodule ArcadeRegions.CoordinateSchema do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :x, :integer
    field :y, :integer
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, ~w/x y/a)
    |> validate_required(~w/x y/a)
  end
end
