defmodule Arcade.HordeRegistry do
  @moduledoc """
  The Registry is responsible for ...
  """

  use Boundary
  use Horde.Registry

  alias Arcade.HordeRegistry

  # Client

  def start_link(_) do
    Horde.Registry.start_link(HordeRegistry, [keys: :unique], name: HordeRegistry)
  end

  def via_tuple(name), do: {:via, Horde.Registry, {HordeRegistry, name}}

  def whereis_name(name) do
    Horde.Registry.whereis_name({HordeRegistry, name})
  end

  @doc false
  def members do
    Enum.map([Node.self() | Node.list()], &{HordeRegistry, &1})
  end

  # Server (callbacks)

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.Registry.init()
  end
end
