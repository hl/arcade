defmodule Arcade.ProcessName do
  @moduledoc """
  The ProcessName is responsible for ...
  """

  @type name :: ArcadeWorlds.name() | ArcadeZones.name()

  @separator "/"

  @spec serialize(name) :: String.t()
  def serialize(name) when is_tuple(name) do
    name
    |> Tuple.to_list()
    |> Enum.map_join(@separator, &to_string/1)
  end

  @spec parse(String.t()) :: name
  def parse(name) do
    name
    |> String.split(@separator)
    |> Enum.reduce({[], 0}, &parse_item(&1, &2))
    |> then(&elem(&1, 0))
    |> Enum.reverse()
    |> List.to_tuple()
  end

  @doc false
  @spec parse_item(item, {[item], non_neg_integer()}) :: {[item], non_neg_integer()}
        when item: atom() | String.t() | non_neg_integer()
  def parse_item(item, acc)

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
