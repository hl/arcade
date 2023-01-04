defmodule ArcadeRegionsTest do
  alias Arcade.HordeRegistry
  use Arcade.HordeCase

  describe "Region.start_child/2" do
    setup do
      world_name = "world"
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_iid = HordeRegistry.get_key(pid)

      [world_iid: world_iid]
    end

    test "start a new supervised region", %{world_iid: world_iid} do
      region_name = "region"

      assert {:ok, _pid} = ArcadeRegions.start_child(region_name, world_iid)
    end

    test "check if region is registered on the world", %{world_iid: world_iid} do
      region_name = "region"
      {:ok, pid} = ArcadeRegions.start_child(region_name, world_iid)
      region_iid = HordeRegistry.get_key(pid)

      assert region_iid in ArcadeWorlds.get_regions(world_iid)
    end
  end
end
