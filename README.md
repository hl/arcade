# Arcade

```
{:ok, _world_process} = Arcade.HordeDynamicSupervisor.start_child(Arcade.WorldProcess)

GenServer.call(Arcade.WorldProcess.via_tuple(), :hello)
```