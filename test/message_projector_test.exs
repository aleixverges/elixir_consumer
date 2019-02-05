defmodule MessageProjectorTest do
  use ExUnit.Case
  doctest MessageProjector

  test "subscribe to queue of a certain name" do
    assert Consumer.start("some_queue") == {:ok, "amq.ctag-5L8U-n0HU5doEsNTQpaXWg"}
  end
end
