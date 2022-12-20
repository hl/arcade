defmodule Arcade.Worlds.WorldState do
  @moduledoc false

  defstruct [:map]

  def new(args \\ %{}) do
    struct!(__MODULE__, args)
  end

  def set_map(state, map) do
    %{state | map: map}
  end

  def get_map(%__MODULE__{map: map}) do
    map
  end
end
