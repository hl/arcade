defmodule ArcadeRegionsTest do
  use Arcade.HordeCase

  describe "Region.start_child/2" do
    setup do
      world_name = random_name("world")
      ArcadeWorlds.start_child(world_name)

      [world_name: world_name]
    end

    test "start a new supervised region", %{world_name: world_name} do
      region_name = random_name("region")

      assert {:ok, _pid} = ArcadeRegions.start_child(region_name, world_name)
    end

    test "check if region is registered on the world", %{world_name: world_name} do
      region_name = random_name("region")
      ArcadeRegions.start_child(region_name, world_name)

      assert region_name in ArcadeWorlds.get_regions(world_name)
    end
  end
end
