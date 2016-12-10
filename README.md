docker-kafka
------------

A basic Kafka setup with Docker, without any `ENV` mappings. Bring your own `server.properties` file!

## usage

Using Docker Compose:

```
docker-compose up
kafkacat -L -b localhost:9092
```

To use your own `server.properties` file, run something like:

```
docker run --rm -v $PWD/server.properties:/etc/kafka/server.properties dylanmei/kafka
```

To override `server.properties`, run the `kafka-server-start.sh` command with `--override` arguments:

```
docker run --rm dylanmei/kafka bin/kafka-server-start.sh \
  config/server.properties \
  --override broker.id=123 \
  --override zookeeper.connect=example:2181
```
