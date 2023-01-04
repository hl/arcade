defmodule Arcade.HordeCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Arcade.HordeRegistry

      import Arcade.HordeCase
    end
  end

  def random_name(subject), do: "test-#{subject}-#{:rand.uniform(10_000)}"
end
