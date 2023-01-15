generate_world = fn name ->
  {:ok, world_pid} = ArcadeWorlds.start_child(name, [map: "#{name}-map-1"])
  Arcade.Registry.get_name(world_pid)
end

generate_island = fn name, world_name, x, y ->
  {:ok, island_pid} = ArcadeIslands.start_child(name, world_name, x, y)
  Arcade.Registry.get_name(island_pid)
end