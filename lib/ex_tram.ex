defmodule ExTram do
  @moduledoc """
  FSM for a tram

  ## State Machine Diagram
   ```mermaid
   stateDiagram-v2
       direction LR
       [*] --> depot
       depot --> tram_stop: :start
       tram_stop --> move: :close_doors
       move --> braking: :stop_sign
       braking --> tram_stop: :open_doors
       tram_stop --> depot: :finish
  """

  use GenServer

  # Client

  @doc """
  Starts process under the name :tram.
  Initial state: :depot.
  """
  def start_link(_opts \\ []), do: GenServer.start_link(__MODULE__, :depot, name: :tram)

  @doc """
  Trigger state by the event
  Events: :start, :close_doors, :stop_sign, :open_doors, :finish
  """
  def trigger(event), do: GenServer.cast(:tram, event)

  @doc """
  Current state of the tram.
  """
  def location, do: GenServer.call(:tram, :get_state)

  # Server

  def init(initial_state), do: {:ok, initial_state}

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_cast(event, state) do
    new_state = transition(state, event)
    if new_state != state, do: IO.puts("Tram Event: [#{event}] | Transition: #{state} -> #{new_state}")
    {:noreply, new_state}
  end

  # Transitions

  # depot -> tram_stop: start
  defp transition(:depot, :start), do: :tram_stop

  # tram_stop -> move: close_doors
  defp transition(:tram_stop, :close_doors), do: :move

  # move -> braking: stop_sign
  defp transition(:move, :stop_sign), do: :braking

  # braking -> tram_stop: stop, open_doors
  defp transition(:braking, :open_doors), do: :tram_stop

  # tram_stop -> depot: finish
  defp transition(:tram_stop, :finish), do: :depot
end
