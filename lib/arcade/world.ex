defmodule Arcade.World do
  @moduledoc """
  The World is responsible for ...
  """

  alias Arcade.Registry
  alias Arcade.WorldProcess
  alias Arcade.WorldSupervisor

  def start(name) when is_binary(name) do
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
