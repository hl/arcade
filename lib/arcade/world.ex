defmodule Arcade.World do
  @moduledoc """
  The World is responsible for ...
  """

  alias Arcade.WorldProcess
  alias Arcade.WorldSupervisor

  def start_child(name) when is_binary(name) do
    [name: name]
    |> WorldProcess.child_spec()
    |> WorldSupervisor.start_child()
  end

  def set_map(name, map) do
    name
    |> Arcade.Registry.via_tuple()
    |> WorldProcess.set_map(map)
  end

  def get_map(name) do
    name
    |> Arcade.Registry.via_tuple()
    |> WorldProcess.get_map()
  end

  def register_region(name, region_name) do
    name
    |> Arcade.Registry.via_tuple()
    |> WorldProcess.register_region(region_name)
  end

  def unregister_region(name, region_name) do
    name
    |> Arcade.Registry.via_tuple()
    |> WorldProcess.unregister_region(region_name)
  end

  def get_regions(name) do
    name
    |> Arcade.Registry.via_tuple()
    |> WorldProcess.get_regions()
  end
end
