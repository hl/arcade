defmodule Arcade.HordeCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Arcade.HordeCase
    end
  end

  def random_name(subject), do: "test-#{subject}-#{:rand.uniform(10_000)}"
end
