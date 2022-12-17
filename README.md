# Arcade

```
iex --name node1@127.0.0.1 --cookie arcade -S mix

{:ok, _world_process} = Arcade.HordeDynamicSupervisor.start_child(Arcade.WorldProcess)

GenServer.call(Arcade.WorldProcess.via_tuple(), :hello)
```