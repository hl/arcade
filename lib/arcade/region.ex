defmodule Arcade.Region do
  @moduledoc """
  The Region is responsible for ...
  """

  alias Arcade.RegionProcess
  alias Arcade.RegionSupervisor

  def start_child(world_name, name) when is_binary(world_name) and is_binary(name) do
    [world_name: world_name, name: name]
    |> RegionProcess.child_spec()
    |> RegionSupervisor.start_child()
  end
end
