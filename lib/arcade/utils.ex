defmodule Arcade.Utils do
  @moduledoc false

  @spec struct_to_map(struct()) :: %{atom() => term()}
  def struct_to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.new(fn
      {k, v} when is_struct(v) -> {k, struct_to_map(v)}
      {k, [e | _] = v} when is_struct(e) -> {k, Enum.map(v, &struct_to_map/1)}
      {k, v} -> {k, v}
    end)
  end
end
