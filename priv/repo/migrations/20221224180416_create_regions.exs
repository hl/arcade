defmodule Arcade.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :name, :string, null: false
      add :world_name, :string, null: false
      add :coordinates, :decimal
      timestamps()
    end

    create unique_index(:regions, [:name, :coordinates])
  end
end
