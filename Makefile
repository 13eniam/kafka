list-topics:
	@docker run \
	--net=uacbitpusher_default \
	--rm \
	confluentinc/cp-kafka:3.3.0 \
	kafka-topics --zookeeper zookeeper:2181 --list	

create-es-test-topic:
	@docker run \
	--net=uacbitpusher_default \
	--rm \
	confluentinc/cp-kafka:3.3.0 \
	kafka-topics --zookeeper zookeeper:2181 --create --topic es-test-topic \
	--replication-factor 1 --partitions 1

delete-es-test-topic:
	@docker run \
	--net=uacbitpusher_default \
	--rm \
	confluentinc/cp-kafka:3.3.0 \
	kafka-topics --zookeeper zookeeper:2181 --delete --topic es-test-topic

create-kafka-es-connector:
	curl -X POST -H 'Content-Type: application/json'  http://uac_docker:8083/connectors --data '{ \
	"name":"elastic-test-connector", \
	"config":{ \
	"connector.class":"io.confluent.connect.elasticsearch.ElasticsearchSinkConnector", \
	"connection.url":"http://elasticsearch:9200", \
	"type.name":"test-data", \
	"topics":"es-test-topic", \
	"topic.index.map":"es-test-topic:es-test-index", \
	"key.ignore":true, \
	"schema.ignore":true} \
	}'

delete-kafka-es-connector:
	curl -X DELETE http://uac_docker:8083/connectors/elastic-test-connector

list-kafka-connectors:
	curl -s http://uac_docker:8083/connectors

setup-test: create-es-test-topic create-kafka-es-connector

teardown-test: delete-kafka-es-connector delete-es-test-topic
