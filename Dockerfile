FROM java:openjdk-8-jre-alpine

ARG VERSION=2.11-0.10.0.0
ARG ARCHIVE=http://apache.mirrors.pair.com/kafka/0.10.0.0/kafka_$VERSION.tgz

LABEL name="kafka" version=$VERSION

RUN apk add --no-cache curl bash \
    && mkdir -p /opt/ \
    && curl -L $ARCHIVE -o /opt/kafka.tar.gz && \
    cd /opt/ && tar -xzvf kafka.tar.gz && \
    mv kafka_$VERSION kafka &&
    rm -Rf kafka.tar.gz

WORKDIR /opt/kafka

ENV KAFKA_HOME /opt/kafka

VOLUME ["/kafka"]

CMD ["/bin/bash"]
