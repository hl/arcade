defmodule ArcadeRegionsTest do
  use ExUnit.Case

  describe("Region.start_child/2") do
    setup do
      world_name = "test-world-#{:rand.uniform()}"
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_name = Arcade.Registry.get_name(pid)
      coordinates = Decimal.from_float(0.0)

      [world_name: world_name, coordinates: coordinates]
    end

    test "start a new supervised region", %{world_name: world_name, coordinates: coordinates} do
      region_name = "test-region"

      assert {:ok, _pid} = ArcadeRegions.start_child(region_name, world_name, coordinates)
    end

    test "check if region is registered on the world", %{
      world_name: world_name,
      coordinates: coordinates
    } do
      region_name = "test-region"
      {:ok, pid} = ArcadeRegions.start_child(region_name, world_name, coordinates)
      region_name = Arcade.Registry.get_name(pid)

      assert region_name in ArcadeWorlds.get_regions(world_name)
    end

    test "check if region has correct coordinates", %{world_name: world_name} do
      region_name = "test-region"
      coordinates = Decimal.from_float(4.7)
      {:ok, pid} = ArcadeRegions.start_child(region_name, world_name, coordinates)
      region_name = Arcade.Registry.get_name(pid)

      assert %{x: 4, y: 7} = ArcadeRegions.get_coordinates(region_name)
    end
  end
end
