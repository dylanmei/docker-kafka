docker-kafka
------------

A basic Kafka setup with Docker, without any `ENV` mappings. Bring your own `server.properties` file!

## usage

Using Docker Compose:

```
docker-compose up
kafkacat -L -b localhost:9092
```
