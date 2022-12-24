defmodule Arcade.Registry do
  @moduledoc """
  The Registry is responsible for ...
  """

  use Horde.Registry

  # Client

  def start_link(_) do
    Horde.Registry.start_link(Arcade.Registry, [keys: :unique], name: Arcade.Registry)
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Arcade.Registry, name}}

  def whereis_name(name) do
    Horde.Registry.whereis_name({Arcade.Registry, name})
  end

  @doc false
  def members do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {Arcade.Registry, node} end)
  end

  # Server (callbacks)

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.Registry.init()
  end
end
