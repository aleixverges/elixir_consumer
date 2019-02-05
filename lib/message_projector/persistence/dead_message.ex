defmodule MessageProjector.Persistence.DeadMessage do
  use Memento.Table,
  attributes: [:id, :registered_at, :payload],
  index: [:registered_at],
  type: :ordered_set,
  autoincrement: true
end
