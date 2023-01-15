defmodule ArcadeWorlds.WorldSchema do
  @moduledoc """
  The World schema is responsible for ...
  """

  use Ecto.Schema

  alias Arcade.ProcessName
  alias Arcade.Repo
  alias ArcadeWorlds.WorldSchema

  import Ecto.Changeset

  @type t :: %WorldSchema{
          id: non_neg_integer() | nil,
          name: ArcadeWorlds.name() | nil,
          map: String.t() | nil,
          islands: [ArcadeIslands.name()],
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "worlds" do
    field :name
    field :map
    field :islands, {:array, :string}
    timestamps()
  end

  @spec save!(t, map()) :: t | no_return()
  def save!(%WorldSchema{} = struct, attrs) do
    struct
    |> cast(attrs, ~w/name map islands/a)
    |> validate_required(~w/name/a)
    |> Repo.insert_or_update!()
  end

  @spec get_by_name(ArcadeWorlds.name()) :: t | nil
  def get_by_name(name) when is_tuple(name) do
    name |> ProcessName.serialize() |> get_by_name()
  end

  @spec get_by_name(String.t()) :: t | nil
  def get_by_name(name) when is_binary(name) do
    Repo.get_by(WorldSchema, name: name)
  end
end
