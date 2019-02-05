defmodule MessageProjectorTest do
  use ExUnit.Case
  doctest MessageProjector

  test "greets the world" do
    assert MessageProjector.hello() == :world
  end
end
