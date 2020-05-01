defmodule IslandsEngine.GameSupervisor do
  use DynamicSupervisor

  alias IslandsEngine.Game



  # START_LINK

  def start_link(_options),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)



  # INIT

  def init(:ok),
    do: DynamicSupervisor.init(strategy: :one_for_one)



  # START_GAME

  def start_game(name) do
    # TODO: update to new child specs, c.f.
    # https://hexdocs.pm/elixir/master/DynamicSupervisor.html
    spec = %{id: Game, start: {Game, :start_link, [name]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end



  # STOP_GAME

  def stop_game(name) do
    :ets.delete(:game_state, name)
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))
  end


  defp pid_from_name(name) do
    name
    |> Game.via_tuple
    |> GenServer.whereis
  end
end
