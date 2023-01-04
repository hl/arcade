defmodule ArcadeWorldsTest do
  alias Arcade.HordeRegistry
  use Arcade.HordeCase

  describe "World.start_child/1" do
    test "start a new supervised world" do
      {:ok, pid} = ArcadeWorlds.start_child("world")
      world_iid = HordeRegistry.get_key(pid)

      assert {:world, name, num} = world_iid
      assert is_binary(name)
      assert is_integer(num)
    end
  end

  describe "World.set_map/2" do
    setup do
      world_name = "world"
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_iid = HordeRegistry.get_key(pid)

      [world_iid: world_iid]
    end

    test "set a map for a world process", %{world_iid: world_iid} do
      map_name = "map"
      assert :ok = ArcadeWorlds.set_map(world_iid, map_name)
    end
  end

  describe "World.get_map/1" do
    setup do
      world_name = "world"
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_iid = HordeRegistry.get_key(pid)

      [world_iid: world_iid]
    end

    test "get a map for a world process", %{world_iid: world_iid} do
      map_name = "map"
      ArcadeWorlds.set_map(world_iid, map_name)

      assert match?(^map_name, ArcadeWorlds.get_map(world_iid))
    end
  end
end
