defmodule Arcade.HordeRegistry do
  @moduledoc """
  The Registry is responsible for ...
  """

  use Boundary
  use Horde.Registry

  # Client

  def start_link(_) do
    Horde.Registry.start_link(Arcade.HordeRegistry, [keys: :unique], name: Arcade.HordeRegistry)
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Arcade.HordeRegistry, name}}

  def whereis_name(name) do
    Horde.Registry.whereis_name({Arcade.HordeRegistry, name})
  end

  def get_key(pid) do
    case Horde.Registry.keys(Arcade.HordeRegistry, pid) do
      [key] -> key
      _empty -> nil
    end
  end

  def select(spec) do
    Horde.Registry.select(Arcade.HordeRegistry, spec)
  end

  def next_key(type, name) do
    case select([{{{type, name, :"$1"}, :_, :_}, [], [:"$1"]}]) do
      [] -> 1
      list -> Enum.max(list) + 1
    end
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{Arcade.HordeRegistry, &1})
  end

  # Server (callbacks)

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.Registry.init()
  end
end
