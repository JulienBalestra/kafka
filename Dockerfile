FROM java:openjdk-8-jre-alpine

ARG VERSION=2.11-0.10.0.0
ARG ARCHIVE=http://apache.mirrors.pair.com/kafka/0.10.0.0/kafka_$VERSION.tgz

LABEL name="kafka" version=$VERSION

RUN apk add --no-cache curl bash \
    && mkdir -p /opt/ \
    && curl -L $ARCHIVE -o /opt/kafka.tar.gz && \
    cd /opt/ && tar -xzvf kafka.tar.gz && \
    mv kafka_$VERSION kafka && \
    rm -Rf kafka.tar.gz && \
    cp /opt/kafka/bin/kafka-server-start.sh /opt/kafka/bin/kafka-server-start.sh.original 

WORKDIR /opt/kafka

COPY kafka-server-start.sh /opt/kafka/bin/kafka-server-start.sh

ENV KAFKA_HOME /opt/kafka

VOLUME ["/kafka/data", "/kafka/conf"]

ENTRYPOINT ["/opt/kafka/bin/kafka-server-start.sh"]

CMD ["/kafka/conf/server.properties"]
