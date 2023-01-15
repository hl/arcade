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

  @spec via_tuple(name) :: {:via, module(), {module(), name}} when name: tuple()
  def via_tuple(name), do: {:via, Horde.Registry, {Arcade.Registry, name}}

  @spec whereis_name(tuple()) :: pid() | :undefined
  def whereis_name(name) do
    Horde.Registry.whereis_name({Arcade.Registry, name})
  end

  @spec get_name(pid()) :: tuple() | nil
  def get_name(pid) do
    case Horde.Registry.keys(Arcade.Registry, pid) do
      [key] -> key
      _empty -> nil
    end
  end

  @spec members() :: [{module(), String.t()}]
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
