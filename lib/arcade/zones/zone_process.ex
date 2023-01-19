defmodule Arcade.Zones.ZoneProcess do
  @moduledoc """
  The Zone process is responsible for ...
  """

  use GenServer

  require Logger

  alias Arcade.ProcessName
  alias Arcade.Worlds
  alias Arcade.Zones.ZoneProcess
  alias Arcade.Zones.ZoneState

  # Client

  @spec child_spec(Keyword.t()) :: Supervisor.child_spec()
  def child_spec(args) do
    name = args |> Keyword.fetch!(:name) |> ProcessName.serialize()

    %{
      id: "#{ZoneProcess}_#{name}",
      start: {ZoneProcess, :start_link, [args]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  @spec start_link(Keyword.t()) :: Supervisor.on_start()
  def start_link(args) do
    name = Keyword.fetch!(args, :name)

    case GenServer.start_link(ZoneProcess, args, name: Arcade.Registry.via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  @spec get_coordinates(pid()) :: %{x: non_neg_integer(), y: non_neg_integer()}
  def get_coordinates(server) do
    GenServer.call(server, :get_coordinates)
  end

  # Server (callbacks)

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)

    name = Keyword.fetch!(args, :name)
    world_name = Keyword.fetch!(args, :world_name)

    Worlds.register_zone(world_name, name)

    {:ok, args, {:continue, :initial_setup}}
  end

  @impl GenServer
  def handle_call(:get_coordinates, _from, state) do
    coordinates = ZoneState.get_coordinates(state)
    {:reply, coordinates, state}
  end

  @impl GenServer
  def handle_continue(:initial_setup, args) do
    name = Keyword.fetch!(args, :name)
    state = ZoneState.load_state(name, args)

    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    Logger.info(inspect(reason))
    ZoneState.save_state(state)
    Worlds.unregister_zone(state.world_name, state.name)

    reason
  end
end
