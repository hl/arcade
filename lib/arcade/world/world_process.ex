defmodule Arcade.WorldProcess do
  use GenServer
  require Logger

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
    case GenServer.start_link(__MODULE__, [], name: via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def init(_args) do
    {:ok, nil}
  end

  def handle_call(:hello, _from, state) do
    {:reply, "Hello from #{inspect(Node.self())}", state}
  end

  def via_tuple(name \\ __MODULE__), do: {:via, Horde.Registry, {Arcade.HordeRegistry, name}}
end
