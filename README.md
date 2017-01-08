docker-kafka
------------

A basic Kafka+Jolokia setup with Docker, without any `ENV` mappings. Bring your own `server.properties` file!

## usage

Using Docker Compose:

```
% docker-compose up
% kafkacat -L -b localhost:9092
% echo "hello" | kafkacat -P -b localhost:9092 -t hello-logs
% kafkacat -C -b localhost:9092 -t hello-logs
```

To use your own `server.properties` file, run something like:

```
docker run --rm -v $PWD/server.properties:/etc/kafka/server.properties dylanmei/kafka
```

To override `server.properties` values, run the `kafka-server-start.sh` command with `--override` arguments:

```
docker run --rm dylanmei/kafka bin/kafka-server-start.sh \
  config/server.properties \
  --override broker.id=123 \
  --override zookeeper.connect=example:2181
```

## jolokia

Use the [Jolokia API](https://jolokia.org/reference/html/protocol.html) endpoint to query for metrics. Example:

```
% curl -s http://localhost:8778/jolokia/search/java.lang:type=* | jq '.'
% curl -s http://localhost:8778/jolokia/read/java.lang:type=ClassLoading | jq '.'
```

[J4PSH](https://github.com/rhuss/jmx4perl) is another way to explore Jolokia. Example:

```
% docker run --rm -it \
  --network=dockerkafka_default \
  jolokia/jmx4perl j4psh --color=no http://kafka-broker:8778/jolokia
```

