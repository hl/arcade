defmodule Arcade.WorldsTest do
  use ArcadeTest.ProcessCase

  alias Arcade.Worlds

  describe "Arcade.Worlds.start_child/1" do
    setup [:setup_world]

    test "start a new supervised world", %{world_name: world_name} do
      assert {:world, name} = world_name
      assert is_binary(name)
    end
  end

  describe "Arcade.Worlds.set_map/2" do
    setup [:setup_world]

    test "set a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      assert :ok = Worlds.set_map(world_name, map_name)
    end
  end

  describe "Arcade.Worlds.get_map/1" do
    setup [:setup_world]

    test "get a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      Worlds.set_map(world_name, map_name)

      assert match?(^map_name, Worlds.get_map(world_name))
    end
  end
end
