defmodule ArcadeZones.ZoneName do
  @moduledoc false

  use Puid, bits: 128, chars: :alphanum_lower
end
