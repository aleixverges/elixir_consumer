defmodule MessageProjector.Consumer do
  use GenServer
  use AMQP

  @host Application.get_env(:message_projector, :host)
  @username Application.get_env(:message_projector, :username)
  @password Application.get_env(:message_projector, :password)
  @virtual_host Application.get_env(:message_projector, :virtual_host)
  @exchange    "dead-letters"
  @queue       "dead_final"
  @queue_error "#{@queue}_error"

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_opts) do
    rabbitmq_connect()
  end

  defp rabbitmq_connect do
    case Connection.open([
      host: @host,
      username: @username,
      password: @password,
      virtual_host: @virtual_host
    ]) do
      {:ok, conn} ->
        # Get notifications when the connection goes down
        Process.monitor(conn.pid)
        # Everything else remains the same
        {:ok, chan} = Channel.open(conn)
        Basic.qos(chan, prefetch_count: 10)
        {:ok, _consumer_tag} = Basic.consume(chan, @queue)
        {:ok, chan}

      {:error, _} ->
        # Reconnection loop
        :timer.sleep(10000)
        rabbitmq_connect()
    end
  end

  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    {:ok, chan} = rabbitmq_connect()
    {:noreply, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    IO.puts("Process registered as a consumer with tag: #{consumer_tag}")
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    IO.puts("Consumer #{consumer_tag} unexpectedly cancelled")
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    IO.puts("Consumer #{consumer_tag} performed a Basic.cancel")
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    IO.puts "Message received: #{payload}"
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  defp consume(channel, tag, redelivered, payload) do
    MessageProjector.Handler.handle(payload)
    :ok = Basic.ack channel, tag

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Error saving #{payload} to database"
  end
end
