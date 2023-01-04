defmodule Arcade.HordeCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Arcade.HordeRegistry

      import Arcade.HordeCase
    end
  end
end
