defmodule ArcadeZonesTest do
  use ArcadeTest.ProcessCase

  describe("Zone.start_child/2") do
    setup [:setup_world]

    test "start a new supervised zone", %{world_name: world_name} do
      zone_name = random_name("test-zone")

      assert {:ok, _pid} = ArcadeZones.start_child(zone_name, world_name, 0, 0)
    end

    test "check if zone is registered on the world", %{world_name: world_name} do
      zone_name = random_name("test-zone")
      {:ok, pid} = ArcadeZones.start_child(zone_name, world_name, 0, 0)
      zone_name = Arcade.Registry.get_name(pid)

      assert zone_name in ArcadeWorlds.get_zones(world_name)
    end

    test "check if zone has correct coordinates", %{world_name: world_name} do
      zone_name = random_name("test-zone")
      {:ok, pid} = ArcadeZones.start_child(zone_name, world_name, 4, 7)
      zone_name = Arcade.Registry.get_name(pid)

      assert %{x: 4, y: 7} = ArcadeZones.get_coordinates(zone_name)
    end
  end
end
