FROM java:openjdk-8-jre-alpine

ARG MIRROR=http://apache.mirrors.pair.com
ARG VERSION=0.10.0.0 
ARG SCALA_VERSION="2.11"

LABEL name="kafka" version=$VERSION

RUN apk add --no-cache wget bash \
    && mkdir /opt \
    && wget -q -O - $MIRROR/zookeeper/$VERSION/kafka_$SCALA_VERSION-$VERSION.tgz | tar -xzf - -C /opt \
    && mv /opt/kafka_$SCALA_VERSION-$VERSION /opt/kafka \
    && mkdir -p /kafka


WORKDIR /opt/kafka

ENV KAFKA_HOME /opt/kafka

VOLUME ["/kafka"]

CMD ["/bin/bash"]
