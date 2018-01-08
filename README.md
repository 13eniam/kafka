# Kafka with Elastic Search and Kibana

This project will set up a single node Kafka broker with Zookeeper and Schema Registry node for supporting Avro.
It will also have an Elastic Search container, a Kafka connect container for managing Kafka connectors and a Kibana
container for visualizing Elastic search results.

To setup a test elastic search index that reads off a kafka topic do:

`make test-setup`

This will create a kafka topic called `es-test-topic`, and a Kafka Elastic Search connector called
`elastic-search-connector` which reads off the Kafka topic and inserts the records into an elastic search index called
`es-test-index`.

To insert records into es-test-topic, start an avro-console-consumer by first logging into the schema-registry
container.

`docker-compose exec schema-registry /bin/bash`

`kafka-avro-console-producer --broker-list kafka_broker:9092 --topic es-test-topic --property value.schema=\
'{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}`

This will pause and wait at the command prompt for input. Type the records at the command prompt and press enter to
add more. To end inserting records, press CTRL-C or CTRL-D. Examples of input records are found in the test directory.

When the records are inserted into the Kafka topic `es-test-topic`, the `elastic-search-connector` will read these records
and insert them into the elastic search index `es-test-index`.

You can then create a dashboard in Kibana to see these records by first accessing Kibana as http://$DOCKER_HOST:5601
where $DOCKER_HOST is the IP of the docker machine. This can be found by typing:

`docker-machine ip [docker-machine-name]`

To remove the test setup by deleting `elastic-search-connector` and the elastic search topic `es-test-topic` created in
kafka, do:

`make teardown-test`
