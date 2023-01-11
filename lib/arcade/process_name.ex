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
    |> Enum.reduce({[], 0}, &parse_item(&1, &2))
    |> then(&elem(&1, 0))
    |> Enum.reverse()
    |> List.to_tuple()
  end

  def parse_item(item, {list, 0}) do
    item = String.to_existing_atom(item)
    {[item | list], 1}
  end

  def parse_item(item, {list, idx}) do
    item =
      case Integer.parse(item) do
        {integer, ""} -> integer
        _not_an_integer -> item
      end

    {[item | list], idx + 1}
  end
end
