defmodule MessageProjector.BasicConsumer do

  alias MessageProjector.Handler, as: MessageHandler

  @host Application.get_env(:message_projector, :host)
  @username Application.get_env(:message_projector, :username)
  @password Application.get_env(:message_projector, :password)
  @virtual_host Application.get_env(:message_projector, :virtual_host)

  @connection Application.get_env(:amqp, :connection)
  @channel Application.get_env(:amqp, :channel)
  @queue Application.get_env(:amqp, :queue)

  def start_link(name) do
    {:ok, conn} =
      @connection.open([
        host: @host,
        username: @username,
        password: @password,
        virtual_host: @virtual_host
      ])
    {:ok, chan} = @channel.open(conn)

    @queue.subscribe(
      chan,
      name,
      fn(payload, _meta) -> MessageHandler.handle(payload) end
    )
  end
end
