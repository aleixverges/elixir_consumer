defmodule MessageProjector do
  use Application

  def start(_type, _args) do
    MessageProjector.Supervisor.start_link
  end
end
