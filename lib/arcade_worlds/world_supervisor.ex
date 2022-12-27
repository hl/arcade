defmodule ArcadeWorlds.WorldSupervisor do
  @moduledoc """
  The World supervisor is responsible for ...
  """

  use Horde.DynamicSupervisor

  alias ArcadeWorlds.WorldSupervisor

  # Client

  def start_link(_args) do
    Horde.DynamicSupervisor.start_link(
      WorldSupervisor,
      [strategy: :one_for_one],
      name: WorldSupervisor,
      shutdown: 1000
    )
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(WorldSupervisor, child_spec)
  end

  @doc false
  def members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {WorldSupervisor, node} end)
  end

  # Server (callbacks)

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end
end
