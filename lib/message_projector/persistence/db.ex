defmodule MessageProjector.Persistence.Db do

  alias MessageProjector.Persistence.DeadMessage, as: DeadMessage

  def init() do
    nodes = [node()]
    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    Memento.Table.create!(DeadMessage, disc_copies: nodes)
  end
end
