generate_world = fn name ->
  {:ok, world_pid} = ArcadeWorlds.start_child(name, [map: "#{name}-map-1"])
  Arcade.Registry.get_name(world_pid)
end

generate_zone = fn name, world_name, x, y ->
  {:ok, zone_pid} = ArcadeZones.start_child(name, world_name, x, y)
  Arcade.Registry.get_name(zone_pid)
end
