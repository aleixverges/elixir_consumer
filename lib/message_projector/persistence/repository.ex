defmodule MessageProjector.Persistence.Repository do

  def save do
    receive do
      {:payload, message} -> Memento.transaction! fn ->
        IO.puts("Saving..... #{message}")
        %MessageProjector.Persistence.DeadMessage{
          registered_at: NaiveDateTime.utc_now,
          payload: message
        }|> Memento.Query.write

        IO.puts("Payload persited successfully: #{message}")
      end
    end
  end

  def list do
    Memento.transaction! fn ->
      Memento.Query.all(MessageProjector.Persistence.DeadMessage)
    end
  end
end
