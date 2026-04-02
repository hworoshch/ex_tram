defmodule ExTramTest do
  use ExUnit.Case
  @moduletag :capture_log

  setup do
    # Start new process at every test
    if GenServer.whereis(:tram), do: GenServer.stop(:tram)
    {:ok, pid} = ExTram.start_link()
    {:ok, tram: pid}
  end

  test "initial state is depot" do
    assert ExTram.location() == :depot
  end

  test "full cycle transition", %{tram: _pid} do
    # depot -> tram_stop
    ExTram.trigger(:start)
    assert ExTram.location() == :tram_stop

    # tram_stop -> move
    ExTram.trigger(:close_doors)
    assert ExTram.location() == :move

    # move -> braking
    ExTram.trigger(:stop_sign)
    assert ExTram.location() == :braking

    # braking -> tram_stop
    ExTram.trigger(:open_doors)
    assert ExTram.location() == :tram_stop

    # tram_stop -> depot
    ExTram.trigger(:finish)
    assert ExTram.location() == :depot
  end

  test "multiple stops cycle" do
    ExTram.trigger(:start)

    ExTram.trigger(:close_doors)
    ExTram.trigger(:stop_sign)
    ExTram.trigger(:open_doors)
    assert ExTram.location() == :tram_stop

    ExTram.trigger(:close_doors)
    ExTram.trigger(:stop_sign)
    ExTram.trigger(:open_doors)
    assert ExTram.location() == :tram_stop
  end
end
