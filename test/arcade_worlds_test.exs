defmodule ArcadeWorldsTest do
  use ArcadeTest.ProcessCase

  describe "ArcadeWorlds.start_child/1" do
    setup [:setup_world]

    test "start a new supervised world", %{world_name: world_name} do
      assert {:world, name} = world_name
      assert is_binary(name)
    end
  end

  describe "ArcadeWorlds.set_map/2" do
    setup [:setup_world]

    test "set a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      assert :ok = ArcadeWorlds.set_map(world_name, map_name)
    end
  end

  describe "ArcadeWorlds.get_map/1" do
    setup [:setup_world]

    test "get a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      ArcadeWorlds.set_map(world_name, map_name)

      assert match?(^map_name, ArcadeWorlds.get_map(world_name))
    end
  end
end
