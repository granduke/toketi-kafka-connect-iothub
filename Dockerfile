FROM hseeberger/scala-sbt:8u151-2.12.4-1.1.0 as sbt
RUN mkdir /toketi-kafka-connector-iothub
WORKDIR /toketi-kafka-connector-iothub
COPY . /toketi-kafka-connector-iothub/
RUN sbt assembly
FROM alpine:3.5
RUN mkdir /jars
RUN mkdir /jars/kafka-connect-iothub
COPY --from=sbt /toketi-kafka-connector-iothub/target/scala-2.11/*.jar /jars/kafka-connect-iothub
