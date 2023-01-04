defmodule Arcade.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :iid, :string, null: false
      add :name, :string, null: false
      add :world_iid, :string, null: false
      timestamps()
    end

    create unique_index(:regions, [:iid])
    create index(:regions, [:world_iid])
  end
end
