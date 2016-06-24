#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Issue http://stackoverflow.com/questions/17668262/kafka-cant-connect-to-zookeeper-fatal-fatal-error-during-kafkaserverstable-star
# https://cwiki.apache.org/confluence/display/KAFKA/FAQ -> "Why can't my consumers/producers connect to the brokers?"
function workaround {
    echo "127.0.0.1 localhost localhost.localdomain" > /etc/hosts
    for ip in $(ip a | grep -w inet | grep -v "127.0.0.1/8" |
        grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    do
        echo "${ip} $(hostname)" >> /etc/hosts
    done
}

if [ $# -lt 1 ];
then
	echo "USAGE: $0 [-daemon] server.properties [--override property=value]*"
	exit 1
fi
base_dir=$(dirname $0)

if [ "x$KAFKA_LOG4J_OPTS" = "x" ]; then
    export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$base_dir/../config/log4j.properties"
fi

if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
fi

EXTRA_ARGS="-name kafkaServer -loggc"

COMMAND=$1
case $COMMAND in
  -daemon)
    EXTRA_ARGS="-daemon "$EXTRA_ARGS
    shift
    ;;
  *)
    ;;
esac

workaround

exec $base_dir/kafka-run-class.sh $EXTRA_ARGS kafka.Kafka "$@"
