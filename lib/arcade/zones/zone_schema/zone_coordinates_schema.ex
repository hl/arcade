defmodule Arcade.Zones.ZoneCoordinatesSchema do
  @moduledoc """
  The ZoneCoordinates schema is responsible for ...
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Arcade.Zones.ZoneCoordinatesSchema

  @type t :: %__MODULE__{
          x: non_neg_integer() | nil,
          y: non_neg_integer() | nil
        }

  @primary_key false

  embedded_schema do
    field :x, :integer
    field :y, :integer
  end

  @spec changeset(t, map()) :: t | Ecto.Changeset.t()
  def changeset(%ZoneCoordinatesSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/x y/a)
    |> validate_required(~w/x y/a)
  end
end
