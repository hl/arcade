defmodule ArcadeWorlds.WorldDynamicSupervisor do
  @moduledoc """
  The World supervisor is responsible for ...
  """

  use Horde.DynamicSupervisor

  alias ArcadeWorlds.WorldDynamicSupervisor

  # Client

  def start_link(_args) do
    Horde.DynamicSupervisor.start_link(
      WorldDynamicSupervisor,
      [strategy: :one_for_one],
      name: WorldDynamicSupervisor,
      shutdown: 10_000
    )
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(WorldDynamicSupervisor, child_spec)
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{WorldDynamicSupervisor, &1})
  end

  # Server (callbacks)

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end
end
