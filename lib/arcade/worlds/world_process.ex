defmodule Arcade.Worlds.WorldProcess do
  @moduledoc """
  The World process is responsible for ...
  """

  use GenServer

  require Logger

  alias Arcade.ProcessName
  alias Arcade.Worlds.WorldProcess
  alias Arcade.Worlds.WorldState

  # Client

  @spec child_spec(Keyword.t()) :: Supervisor.child_spec()
  def child_spec(args) do
    name = args |> Keyword.fetch!(:name) |> ProcessName.serialize()

    %{
      id: "#{WorldProcess}_#{name}",
      start: {WorldProcess, :start_link, [args]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  @spec start_link(Keyword.t()) :: Supervisor.on_start()
  def start_link(args) do
    name = Keyword.fetch!(args, :name)

    case GenServer.start_link(WorldProcess, args, name: Arcade.Registry.via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  @spec set_map(pid(), String.t()) :: :ok
  def set_map(server, map) do
    GenServer.cast(server, {:set_map, map})
  end

  @spec register_zone(pid(), Arcade.Zones.name()) :: :ok
  def register_zone(server, zone_name) do
    GenServer.cast(server, {:register_zone, zone_name})
  end

  @spec unregister_zone(pid(), Arcade.Zones.name()) :: :ok
  def unregister_zone(server, zone_name) do
    GenServer.cast(server, {:unregister_zone, zone_name})
  end

  @spec get_map(pid()) :: String.t() | nil
  def get_map(server) do
    GenServer.call(server, :get_map)
  end

  @spec get_zones(pid()) :: [Arcade.Zones.name()]
  def get_zones(server) do
    GenServer.call(server, :get_zones)
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
    state = WorldState.load_state(name, args)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:get_map, _from, state) do
    map = WorldState.get_map(state)
    {:reply, map, state}
  end

  @impl GenServer
  def handle_call(:get_zones, _from, state) do
    map = WorldState.get_zones(state)
    {:reply, map, state}
  end

  @impl GenServer
  def handle_cast({:set_map, map}, state) do
    state = WorldState.set_map(state, map)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:register_zone, zone_name}, state) do
    state = WorldState.register_zone(state, zone_name)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:unregister_zone, zone_name}, state) do
    state = WorldState.unregister_zone(state, zone_name)
    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    Logger.info(inspect(reason))
    WorldState.save_state(state)
    reason
  end
end
