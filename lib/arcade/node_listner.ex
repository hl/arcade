defmodule Arcade.NodeListener do
  use GenServer

  @horde [Arcade.Registry, Arcade.WorldSupervisor]

  # Client

  def start_link(_), do: GenServer.start_link(__MODULE__, [])

  @doc false
  def set_members(horde) do
    Enum.map(horde, fn name ->
      members = Enum.map([Node.self() | Node.list()], &{name, &1})
      :ok = Horde.Cluster.set_members(name, members)
    end)
  end

  # Server (callbacks)

  @impl GenServer
  def init(_) do
    :net_kernel.monitor_nodes(true, node_type: :visible)
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:nodeup, _node, _node_type}, state) do
    set_members(@horde)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:nodedown, _node, _node_type}, state) do
    set_members(@horde)
    {:noreply, state}
  end
end
