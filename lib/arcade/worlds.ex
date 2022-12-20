defmodule Arcade.Worlds do
  alias Arcade.Registry
  alias Arcade.Worlds.WorldProcess
  alias Arcade.Worlds.WorldSupervisor

  def start(name) do
    [name: name]
    |> WorldProcess.child_spec()
    |> WorldSupervisor.start_child()
  end

  def set_map(name, map) do
    name
    |> Registry.via_tuple()
    |> WorldProcess.set_map(map)
  end

  def get_map(name) do
    name
    |> Registry.via_tuple()
    |> WorldProcess.get_map()
  end
end
