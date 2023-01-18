defmodule Arcade.Repo.Migrations.CreateZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string, null: false
      add :world_name, :string, null: false
      add :coordinates, :map
      timestamps()
    end

    create unique_index(:zones, [:name, :coordinates])
  end
end
