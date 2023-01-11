defmodule Arcade.DynamicSupervisor do
  defmacro __using__(_opts) do
    quote do
      use Horde.DynamicSupervisor

      # Client

      def start_link(_args) do
        Horde.DynamicSupervisor.start_link(
          __MODULE__,
          [strategy: :one_for_one],
          name: __MODULE__,
          shutdown: 10_000
        )
      end

      defoverridable start_link: 1

      def start_child(child_spec) do
        Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
      end

      defoverridable start_child: 1

      @doc false
      def members do
        Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
      end

      defoverridable members: 0

      # Server (callbacks)

      def init(args) do
        [members: members()]
        |> Keyword.merge(args)
        |> Horde.DynamicSupervisor.init()
      end

      defoverridable init: 1
    end
  end
end
