defmodule Arcade.NodeListener do
  @moduledoc """
  The Node Listener is responsible for ...
  """

  use Boundary
  use GenServer

  alias Arcade.NodeListener

  # Client

  def start_link(_), do: GenServer.start_link(NodeListener, [])

  @doc false
  def set_members(supervisors) do
    nodes = [Node.self() | Node.list()]

    Enum.map(supervisors, fn supervisor ->
      members = Enum.map(nodes, &{supervisor, &1})
      :ok = Horde.Cluster.set_members(supervisor, members)
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
    set_members(supervisors())
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:nodedown, _node, _node_type}, state) do
    set_members(supervisors())
    {:noreply, state}
  end

  def supervisors do
    [Arcade.Registry, Application.get_env(:arcade, :supervisors)]
  end
end
