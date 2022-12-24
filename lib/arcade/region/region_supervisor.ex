defmodule Arcade.RegionSupervisor do
  @moduledoc """
  The Region supervisor is responsible for ...
  """

  use Horde.DynamicSupervisor

  alias Arcade.RegionSupervisor

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
  def members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {RegionSupervisor, node} end)
  end

  # Server (callbacks)

  def init(args) do
    [members: members()]
    |> Keyword.merge(args)
    |> Horde.DynamicSupervisor.init()
  end
end
