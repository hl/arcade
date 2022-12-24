defmodule Arcade.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :name, :string, null: false
      add :world_name, :string, null: false
      timestamps()
    end

    create unique_index(:regions, [:name, :world_name])
  end
end
