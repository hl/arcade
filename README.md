# Arcade

```
iex --name node1@127.0.0.1 --cookie arcade -S mix
iex --name node2@127.0.0.1 --cookie arcade -S mix

Arcade.Worlds.start("test-world")
Arcade.Worlds.set_map("test-world", "test-map")
Arcade.Worlds.get_map("test-world")
```