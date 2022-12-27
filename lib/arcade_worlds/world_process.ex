defmodule ArcadeWorlds.WorldProcess do
  @moduledoc """
  The World process is responsible for ...
  """

  use GenServer

  require Logger

  alias ArcadeWorlds.WorldProcess
  alias ArcadeWorlds.WorldState

  # Client

  def child_spec(opts) do
    name = Keyword.get(opts, :name, WorldProcess)

    %{
      id: "#{WorldProcess}_#{name}",
      start: {WorldProcess, :start_link, [name]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(name) do
    case GenServer.start_link(WorldProcess, [name: name], name: Arcade.Registry.via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def set_map(server, map) do
    GenServer.cast(server, {:set_map, map})
  end

  def get_map(server) do
    GenServer.call(server, :get_map)
  end

  def register_region(server, region_name) do
    GenServer.cast(server, {:register_region, region_name})
  end

  def unregister_region(server, region_name) do
    GenServer.cast(server, {:unregister_region, region_name})
  end

  def get_regions(server) do
    GenServer.call(server, :get_regions)
  end

  # Server (callbacks)

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)
    {:ok, args, {:continue, :load_state}}
  end

  @impl GenServer
  def handle_continue(:load_state, args) do
    name = Keyword.fetch!(args, :name)
    state = WorldState.load_state(name)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_map, _from, state) do
    map = WorldState.get_map(state)
    {:reply, map, state}
  end

  @impl GenServer
  def handle_call(:get_regions, _from, state) do
    map = WorldState.get_regions(state)
    {:reply, map, state}
  end

  @impl GenServer
  def handle_cast({:set_map, map}, state) do
    state = WorldState.set_map(state, map)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:register_region, region_name}, state) do
    state = WorldState.register_region(state, region_name)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:unregister_region, region_name}, state) do
    state = WorldState.unregister_region(state, region_name)
    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    Logger.info(inspect(reason))
    # TODO: Maybe only save on certain terminate reasons
    WorldState.save_state(state)
    reason
  end
end
