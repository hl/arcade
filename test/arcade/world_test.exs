defmodule Arcade.WorldTest do
  use Arcade.HordeCase

  alias Arcade.World

  describe "World.start_child/1" do
    test "start a new supervised world" do
      assert {:ok, _pid} = World.start_child(random_name("world"))
    end
  end

  describe "World.set_map/2" do
    setup do
      world_name = random_name("world")
      map_name = random_name("map")
      {:ok, _pid} = World.start_child(world_name)

      [world_name: world_name, map_name: map_name]
    end

    test "set a map for a world process", %{world_name: world_name, map_name: map_name} do
      assert :ok = World.set_map(world_name, map_name)
    end
  end

  describe "World.get_map/1" do
    setup do
      world_name = random_name("world")
      map_name = random_name("map")
      {:ok, _pid} = World.start_child(world_name)

      [world_name: world_name, map_name: map_name]
    end

    test "get a map for a world process", %{world_name: world_name, map_name: map_name} do
      World.set_map(world_name, map_name)

      assert match?(^map_name, World.get_map(world_name))
    end
  end
end
