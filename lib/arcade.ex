defmodule Arcade do
  @moduledoc false

  use Boundary, exports: [DynamicSupervisor, ProcessName, Registry, Repo, Utils]
end
