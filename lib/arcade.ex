defmodule Arcade do
  @moduledoc false

  use Boundary, exports: [DynamicSupervisor, Registry, ProcessName, Repo]
end
