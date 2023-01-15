defmodule Arcade.Repo.Migrations.CreateIslands do
  use Ecto.Migration

  def change do
    create table(:islands) do
      add :name, :string, null: false
      add :world_name, :string, null: false
      add :coordinates, :map
      timestamps()
    end

    create unique_index(:islands, [:name, :coordinates])
  end
end
