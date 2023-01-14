{:ok, world_pid} = ArcadeWorlds.start_child("test")
world_name = Arcade.Registry.get_name(world_pid)

{:ok, region_pid} = ArcadeRegions.start_child("test", world_name, 0, 0)
region_name = Arcade.Registry.get_name(region_pid)