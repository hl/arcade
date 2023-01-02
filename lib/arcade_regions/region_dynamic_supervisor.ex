defmodule ArcadeRegions.RegionDynamicSupervisor do
  @moduledoc """
  The Region supervisor is responsible for ...
  """

  use Horde.DynamicSupervisor

  alias ArcadeRegions.RegionDynamicSupervisor

  # Client

  def start_link(_args) do
    Horde.DynamicSupervisor.start_link(
      RegionDynamicSupervisor,
      [strategy: :one_for_one],
      name: RegionDynamicSupervisor,
      shutdown: 10_000
    )
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(RegionDynamicSupervisor, child_spec)
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{RegionDynamicSupervisor, &1})
  end

  # Server (callbacks)

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end
end
