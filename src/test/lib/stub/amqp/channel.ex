defmodule DeadFinalReader.Test.Stub.Amqp.Channel do
  def open(_) do
    {:ok, "channel"}
  end
end
