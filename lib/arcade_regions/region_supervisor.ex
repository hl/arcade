defmodule ArcadeRegions.RegionSupervisor do
  @moduledoc """
  The Region supervisor is responsible for ...
  """

  use Horde.DynamicSupervisor

  alias ArcadeRegions.RegionSupervisor

  # Client

  def start_link(_args) do
    Horde.DynamicSupervisor.start_link(
      RegionSupervisor,
      [strategy: :one_for_one],
      name: RegionSupervisor,
      shutdown: 1000
    )
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(RegionSupervisor, child_spec)
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{RegionSupervisor, &1})
  end

  # Server (callbacks)

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end
end
