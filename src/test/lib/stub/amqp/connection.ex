defmodule DeadFinalReader.Test.Stub.Amqp.Connection do
  def open(_) do
    {:ok, "connection"}
  end
end
