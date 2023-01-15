{:ok, world_pid} = ArcadeWorlds.start_child("test", [map: "test-map-1"])
world_name = Arcade.Registry.get_name(world_pid)

{:ok, island_pid} = ArcadeIslands.start_child("test", world_name, 0, 0)
island_name = Arcade.Registry.get_name(island_pid)