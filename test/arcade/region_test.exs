defmodule Arcade.RegionTest do
  use Arcade.HordeCase

  alias Arcade.Region
  alias Arcade.World

  describe "Region.start_child/2" do
    setup do
      world_name = random_name("world")
      World.start_child(world_name)

      [world_name: world_name]
    end

    test "start a new supervised region", %{world_name: world_name} do
      region_name = random_name("region")

      assert {:ok, _pid} = Region.start_child(world_name, region_name)
    end

    test "check if region is registered on the world", %{world_name: world_name} do
      region_name = random_name("region")
      Region.start_child(world_name, region_name)

      assert region_name in World.get_regions(world_name)
    end
  end
end
