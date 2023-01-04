defmodule ArcadeRegions.RegionProcess do
  @moduledoc """
  The Region process is responsible for ...
  """

  use GenServer

  require Logger

  alias Arcade.HordeRegistry
  alias Arcade.IID
  alias ArcadeRegions.RegionProcess
  alias ArcadeRegions.RegionState

  # Client

  def child_spec(args) do
    iid = args |> Keyword.fetch!(:iid) |> IID.serialize()

    %{
      id: "#{RegionProcess}_#{iid}",
      start: {RegionProcess, :start_link, [args]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(args) do
    iid = Keyword.fetch!(args, :iid)

    case GenServer.start_link(RegionProcess, args, name: HordeRegistry.via_tuple(iid)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  # Server (callbacks)

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)

    iid = Keyword.fetch!(args, :iid)
    world_iid = Keyword.fetch!(args, :world_iid)

    ArcadeWorlds.register_region(world_iid, iid)

    {:ok, args, {:continue, :initial_setup}}
  end

  @impl GenServer
  def handle_continue(:initial_setup, args) do
    iid = Keyword.fetch!(args, :iid)
    state = RegionState.load_state(iid, args)

    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    Logger.info(inspect(reason))
    RegionState.save_state(state)
    ArcadeWorlds.unregister_region(state.world_iid, state.iid)

    reason
  end
end
