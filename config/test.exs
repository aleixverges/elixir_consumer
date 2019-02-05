use Mix.Config

config :amqp,
  connection: DeadFinalReader.Test.Stub.Amqp.Connection,
  channel: DeadFinalReader.Test.Stub.Amqp.Channel,
  queue: DeadFinalReader.Test.Stub.Amqp.Queue
