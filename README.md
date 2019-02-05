# Elixir Consumer
Elixir consumer to read and persist messages from RabbitMQ. Messages are consumed and persisted in different processes. It requires an external 'rabbitmq' network where a RabbitMQ instance exists.

# Application up and running
Execute the following commands to start consumer

```
docker-compose up -d
docker exec -it [elixir_container] bash

/opt/app# mix deps.get
/opt/app# mix compile
/opt/app# mix run -e "Db.init"
/opt/app# iex -S mix

iex(1)> Consumer.start("dead_final")
```
