defmodule Arcade.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :arcade,
    adapter: Ecto.Adapters.SQLite3
end
