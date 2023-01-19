defmodule ArcadeTest.ProcessCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Arcade.Worlds

  using do
    quote do
      import ArcadeTest.ProcessCase
    end
  end

  def random_name(prefix), do: "#{prefix}-#{Ecto.UUID.generate()}"

  def setup_world(_context) do
    world_name = random_name("test-world")
    {:ok, world_pid} = Worlds.start_child(world_name)
    world_name = Arcade.Registry.get_name(world_pid)

    [world_pid: world_pid, world_name: world_name]
  end
end
