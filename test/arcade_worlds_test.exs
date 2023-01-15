defmodule ArcadeWorldsTest do
  use ExUnit.Case

  def random_name(prefix), do: "#{prefix}-#{Ecto.UUID.generate()}"

  describe "World.start_child/1" do
    test "start a new supervised world" do
      world_name = random_name("test-world")
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_name = Arcade.Registry.get_name(pid)

      assert {:world, name} = world_name
      assert is_binary(name)
    end
  end

  describe "World.set_map/2" do
    setup do
      world_name = random_name("test-world")
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_name = Arcade.Registry.get_name(pid)

      [world_name: world_name]
    end

    test "set a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      assert :ok = ArcadeWorlds.set_map(world_name, map_name)
    end
  end

  describe "World.get_map/1" do
    setup do
      world_name = random_name("test-world")
      {:ok, pid} = ArcadeWorlds.start_child(world_name)
      world_name = Arcade.Registry.get_name(pid)

      [world_name: world_name]
    end

    test "get a map for a world process", %{world_name: world_name} do
      map_name = random_name("test-map")
      ArcadeWorlds.set_map(world_name, map_name)

      assert match?(^map_name, ArcadeWorlds.get_map(world_name))
    end
  end
end
