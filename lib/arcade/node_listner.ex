defmodule Arcade.NodeListener do
  @moduledoc """
  The Node Listener is responsible for ...
  """

  use Boundary
  use GenServer

  alias Arcade.NodeListener

  # Client

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(NodeListener, [])

  @doc false
  def set_members(horde) do
    nodes = [Node.self() | Node.list()]

    Enum.map(horde, fn name ->
      members = Enum.map(nodes, &{name, &1})
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
    set_members(horde())
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:nodedown, _node, _node_type}, state) do
    set_members(horde())
    {:noreply, state}
  end

  @spec horde() :: [module()]
  def horde do
    [Arcade.Registry | Application.get_env(:arcade, :horde)]
  end
end
