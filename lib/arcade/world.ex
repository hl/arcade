defmodule Arcade.World do
  alias Arcade.WorldSupervisor
  alias Arcade.WorldProcess

  def start(name) do
    [name: name]
    |> WorldProcess.child_spec()
    |> WorldSupervisor.start_child()
  end

  def set_map(name, map) do
    name
    |> WorldProcess.via_tuple()
    |> WorldProcess.set_map(map)
  end

  def get_map(name) do
    name
    |> WorldProcess.via_tuple()
    |> WorldProcess.get_map()
  end
end
