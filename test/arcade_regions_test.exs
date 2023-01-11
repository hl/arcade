defmodule ArcadeRegionsTest do
  use ExUnit.Case

  describe("Region.start_child/2") do
    setup do
      world_name = "test-world-#{:rand.uniform()}"
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_name = Arcade.Registry.get_name(pid)

      [world_name: world_name]
    end

    test "start a new supervised region", %{world_name: world_name} do
      region_name = "test-region"

      assert {:ok, _pid} = ArcadeRegions.start_child(region_name, world_name, 0, 0)
    end

    test "check if region is registered on the world", %{world_name: world_name} do
      region_name = "test-region"
      {:ok, pid} = ArcadeRegions.start_child(region_name, world_name, 0, 0)
      region_name = Arcade.Registry.get_name(pid)

      assert region_name in ArcadeWorlds.get_regions(world_name)
    end

    test "check if region has correct coordinates", %{world_name: world_name} do
      region_name = "test-region"
      {:ok, pid} = ArcadeRegions.start_child(region_name, world_name, 4, 7)
      region_name = Arcade.Registry.get_name(pid)

      assert %{x: 4, y: 7} = ArcadeRegions.get_coordinates(region_name)
    end
  end
end
