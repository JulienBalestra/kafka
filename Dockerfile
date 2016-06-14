FROM java:openjdk-8-jre-alpine

ARG ARCHIVE=http://apache.mirrors.pair.com/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz
ARG VERSION=0.10.0.0

LABEL name="kafka" version=$VERSION

RUN apk add --no-cache curl bash \
    && mkdir /opt/kafka \
    && curl -L $ARCHIVE -o /opt/kafka/kafka.tar.gz && \
    cd /opt/kafka && tar -xzvf kafka.tar.gz --strip-components=1 

WORKDIR /opt/kafka

ENV KAFKA_HOME /opt/kafka

VOLUME ["/kafka"]

CMD ["/bin/bash"]
