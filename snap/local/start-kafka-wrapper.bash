#!/bin/bash

set -eu

if [ ! -f $SNAP_COMMON/server.properties ]; then
	echo "configuration file $SNAP_COMMON/server.properties does not exist."
	exit 1
fi

# Use custom log4j properties if found
if [ -f $SNAP_COMMON/log4j.properties ]; then
	export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$SNAP_COMMON/log4j.properties"
fi

export PATH=$SNAP/usr/lib/jvm/default-java/bin:$PATH
export LOG_DIR=$SNAP_COMMON/log

# JMX is only available on localhost:9999
export JMX_PORT=${JMX_PORT:-9999}
export KAFKA_JMX_OPTS="-Djava.rmi.server.hostname=localhost \
-Djava.net.preferIPv4Stack=true \
-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false"

if [ -e "$SNAP_COMMON/broker.env" ]; then
    . $SNAP_COMMON/broker.env
fi

$SNAP/opt/kafka/bin/kafka-server-start.sh $SNAP_COMMON/server.properties
