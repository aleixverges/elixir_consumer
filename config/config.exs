# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :message_projector,
  host: "rabbitmq_production",
  username: "admin",
  password: "admin",
  virtual_host: "invoicesharing"

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'

config :amqp,
  connection: AMQP.Connection,
  channel: AMQP.Channel,
  queue: AMQP.Queue

import_config "#{Mix.env()}.exs"
