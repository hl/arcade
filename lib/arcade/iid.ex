defmodule Arcade.IID do
  @split_char "/"

  def serialize(iid) do
    iid
    |> Tuple.to_list()
    |> Enum.map(&to_string/1)
    |> Enum.join(@split_char)
  end

  def parse(iid) do
    iid
    |> String.split(@split_char)
    |> List.to_tuple()
  end
end
