defmodule ArcadeRegions.RegionProcess do
  @moduledoc """
  The Region process is responsible for ...
  """

  use GenServer

  require Logger

  alias Arcade.ProcessName
  alias ArcadeRegions.RegionProcess
  alias ArcadeRegions.RegionState

  # Client

  def child_spec(args) do
    name = args |> Keyword.fetch!(:name) |> ProcessName.serialize()

    %{
      id: "#{RegionProcess}_#{name}",
      start: {RegionProcess, :start_link, [args]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(args) do
    name = Keyword.fetch!(args, :name)

    case GenServer.start_link(RegionProcess, args, name: Arcade.Registry.via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def get_coordinates(server) do
    GenServer.call(server, :get_coordinates)
  end

  # Server (callbacks)

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)

    name = Keyword.fetch!(args, :name)
    world_name = Keyword.fetch!(args, :world_name)

    ArcadeWorlds.register_region(world_name, name)

    {:ok, args, {:continue, :initial_setup}}
  end

  @impl GenServer
  def handle_call(:get_coordinates, _from, state) do
    coordinates = RegionState.get_coordinates(state)
    {:reply, coordinates, state}
  end

  @impl GenServer
  def handle_continue(:initial_setup, args) do
    name = Keyword.fetch!(args, :name)
    state = RegionState.load_state(name, args)

    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    Logger.info(inspect(reason))
    RegionState.save_state(state)
    ArcadeWorlds.unregister_region(state.world_name, state.name)

    reason
  end
end
