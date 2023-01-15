defmodule Arcade.Repo.Migrations.CreateWorlds do
  use Ecto.Migration

  def change do
    create table(:worlds) do
      add :name, :string, null: false
      add :map, :string
      add :islands, :map
      timestamps()
    end

    create unique_index(:worlds, [:name])
  end
end
