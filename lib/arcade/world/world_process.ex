defmodule Arcade.WorldProcess do
  use GenServer
  require Logger

  alias Arcade.Registry
  alias Arcade.WorldState

  # Client

  def child_spec(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    %{
      id: "#{__MODULE__}_#{name}",
      start: {__MODULE__, :start_link, [name]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(name) do
    case GenServer.start_link(__MODULE__, [], name: Registry.via_tuple(name)) do
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

  # Server (callbacks)

  @impl GenServer
  def init(_args) do
    {:ok, WorldState.new()}
  end

  @impl GenServer
  def handle_call(:get_map, _from, state) do
    map = WorldState.get_map(state)
    {:reply, map, state}
  end

  @impl GenServer
  def handle_cast({:set_map, map}, state) do
    state = WorldState.set_map(state, map)
    {:noreply, state}
  end
end
