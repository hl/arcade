defmodule Arcade.Schema do
  @moduledoc false

  defmacro __using__(opts) do
    repo = Keyword.fetch!(opts, :repo)

    quote bind_quoted: [repo: repo] do
      Module.put_attribute(__MODULE__, :repo, repo)

      use Ecto.Schema

      import Ecto.Changeset

      alias __MODULE__

      @spec new(map()) :: t()
      def new(attrs \\ %{}) do
        struct(__MODULE__, attrs)
      end

      defoverridable new: 0, new: 1

      @spec to_map(t) :: map()
      def to_map(struct) do
        Arcade.Utils.struct_to_map(struct)
      end

      defoverridable to_map: 1

      @spec get_by_name(tuple() | String.t()) :: t | nil
      def get_by_name(name) when is_tuple(name) do
        name |> Arcade.ProcessName.serialize() |> get_by_name()
      end

      def get_by_name(name) when is_binary(name) do
        @repo.get_by(__MODULE__, name: name)
      end

      defoverridable get_by_name: 1

      @spec save!(t, map()) :: t | no_return()
      def save!(struct, attrs) do
        struct
        |> __MODULE__.changeset(attrs)
        |> @repo.insert_or_update!()
      end

      defoverridable save!: 2

      @spec fetch!(t, atom()) :: term()
      def fetch!(struct, key) do
        Map.fetch!(struct, key)
      end

      defoverridable fetch!: 2
    end
  end
end
