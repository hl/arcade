defmodule ArcadeIslandsTest do
  use ArcadeTest.ProcessCase

  describe("Island.start_child/2") do
    setup [:setup_world]

    test "start a new supervised island", %{world_name: world_name} do
      island_name = random_name("test-island")

      assert {:ok, _pid} = ArcadeIslands.start_child(island_name, world_name, 0, 0)
    end

    test "check if island is registered on the world", %{world_name: world_name} do
      island_name = random_name("test-island")
      {:ok, pid} = ArcadeIslands.start_child(island_name, world_name, 0, 0)
      island_name = Arcade.Registry.get_name(pid)

      assert island_name in ArcadeWorlds.get_islands(world_name)
    end

    test "check if island has correct coordinates", %{world_name: world_name} do
      island_name = random_name("test-island")
      {:ok, pid} = ArcadeIslands.start_child(island_name, world_name, 4, 7)
      island_name = Arcade.Registry.get_name(pid)

      assert %{x: 4, y: 7} = ArcadeIslands.get_coordinates(island_name)
    end
  end
end
