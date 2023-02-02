defmodule Arcade.ZonesTest do
  use ArcadeTest.ProcessCase

  alias Arcade.Worlds
  alias Arcade.Zones

  describe "Zone.start/2" do
    setup [:setup_world]

    test "start a new supervised zone", %{world_name: world_name} do
      zone_name = random_name("test-zone")

      assert {:ok, _pid} = Zones.start(zone_name, world_name, 0, 0)
    end

    test "check if zone is registered on the world", %{world_name: world_name} do
      zone_name = random_name("test-zone")
      {:ok, pid} = Zones.start(zone_name, world_name, 0, 0)
      zone_name = Arcade.Registry.get_name(pid)

      assert zone_name in Worlds.get_zones(world_name)
    end

    test "check if zone has correct coordinates", %{world_name: world_name} do
      zone_name = random_name("test-zone")
      {:ok, pid} = Zones.start(zone_name, world_name, 4, 7)
      zone_name = Arcade.Registry.get_name(pid)

      assert %{x: 4, y: 7} = Zones.get_coordinates(zone_name)
    end
  end
end
