defmodule Arcade.Worlds.WorldSupervisor do
  use Horde.DynamicSupervisor

  # Client

  def start_link(_) do
    Horde.DynamicSupervisor.start_link(
      __MODULE__,
      [strategy: :one_for_one],
      name: __MODULE__
    )
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc false
  def members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {__MODULE__, node} end)
  end

  # Server (callbacks)

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end
end
