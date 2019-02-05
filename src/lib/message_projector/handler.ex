defmodule MessageProjector.Handler do

  def handle(payload) do
    save_process = spawn_link(MessageProjector.Persistence.Repository, :save, [])
    send(save_process, {:payload, payload})
  end
end
