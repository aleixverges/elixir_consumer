# Elixir Consumer
Elixir consumer to read and persist messages from RabbitMQ. Messages are consumed and persisted in different processes. It requires an external 'rabbitmq' network where a RabbitMQ instance exists.

# Application up and running
Execute the following commands to start consumer

```
$ mix deps.get
$ mix compile
$ mix run -e "Db.init"
$ iex -S mix
```
