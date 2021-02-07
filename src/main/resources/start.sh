#!/bin/bash
cd `dirname $0`
JARFILE=`ls *.jar`
Package_name=${JARFILE%%.jar*}
hostname=`hostname`
if [[ ! -e /data/log/gclogs ]]; then
  mkdir -p /data/log/gclogs
fi
CMD="-XX:+HeapDumpOnOutOfMemoryError \
     -XX:+PrintGCDetails \
     -XX:MaxGCPauseMillis=200 \
     -Xloggc:/data/log/gclogs/${Package_name}_gc.log \
     -XX:HeapDumpPath=/data/log/${Package_name}.hprof"
pid=$(ps uxf|grep ${JARFILE}|grep -v grep|awk '{print $2}')
if [[ -z $pid ]]; then
    cd `dirname $0`
    /usr/bin/java $CMD -jar ${JARFILE} 2>&1 >/dev/null
    echo "${Package_name} started"
else
    echo "${Package_name} is already running"
fi