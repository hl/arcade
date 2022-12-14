defmodule ArcadeTest do
  use ExUnit.Case
  doctest Arcade

  test "greets the world" do
    assert Arcade.hello() == :world
  end
end
