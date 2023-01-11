defmodule Arcade.Registry do
  @moduledoc """
  The Registry is responsible for ...
  """

  use Boundary
  use Horde.Registry

  # Client

  def start_link(_) do
    Horde.Registry.start_link(Arcade.Registry, [keys: :unique], name: Arcade.Registry)
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Arcade.Registry, name}}

  def whereis_name(name) do
    Horde.Registry.whereis_name({Arcade.Registry, name})
  end

  def get_name(pid) do
    case Horde.Registry.keys(Arcade.Registry, pid) do
      [key] -> key
      _empty -> nil
    end
  end

  def select(spec) do
    Horde.Registry.select(Arcade.Registry, spec)
  end

  def next_index(type, name) do
    case select([{{{type, name, :"$1"}, :_, :_}, [], [:"$1"]}]) do
      [] -> 1
      list -> Enum.max(list) + 1
    end
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{Arcade.Registry, &1})
  end

  # Server (callbacks)

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.Registry.init()
  end
end
