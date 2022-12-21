# Arcade

```
iex --name node1@127.0.0.1 --cookie arcade -S mix
iex --name node2@127.0.0.1 --cookie arcade -S mix

Arcade.World.start("test-world"); \
Arcade.World.set_map("test-world", "test-map"); \
Arcade.World.get_map("test-world")
```