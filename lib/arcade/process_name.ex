defmodule Arcade.ProcessName do
  @divider "/"

  def serialize(name) do
    name
    |> Tuple.to_list()
    |> Enum.map(&to_string/1)
    |> Enum.join(@divider)
  end

  def parse(name) do
    name
    |> String.split(@divider)
    |> List.to_tuple()
    |> then(fn tuple ->
      last_idx = tuple_size(tuple) - 1
      type = tuple |> elem(0) |> String.to_existing_atom()
      number = tuple |> elem(last_idx) |> String.to_integer()

      tuple
      |> put_elem(0, type)
      |> put_elem(last_idx, number)
    end)
  end
end
