defmodule DeadFinalReader.Test.Stub.Amqp.Queue do
  def subscribe(_, _, _) do
    {:ok, "amq.ctag-5L8U-n0HU5doEsNTQpaXWg"}
  end
end
