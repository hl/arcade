defmodule Arcade.Repo.Migrations.CreateWorlds do
  use Ecto.Migration

  def change do
    create table(:worlds) do
      add :iid, :string, null: false
      add :name, :string, null: false
      add :map, :string
      add :regions, :map
      timestamps()
    end

    create unique_index(:worlds, [:name])
  end
end
