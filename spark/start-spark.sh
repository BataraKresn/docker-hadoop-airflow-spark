#!/bin/bash

. "$SPARK_HOME/bin/load-spark-env.sh"

# Determine Spark workload
case "$SPARK_WORKLOAD" in
  "master")
    export SPARK_MASTER_HOST=`hostname`
    cd $SPARK_HOME/bin && \
      ./spark-class org.apache.spark.deploy.master.Master \
        --ip $SPARK_MASTER_HOST \
        --port $SPARK_MASTER_PORT \
        --webui-port $SPARK_MASTER_WEBUI_PORT \
        >> $SPARK_MASTER_LOG
    ;;
  
  "worker")
    cd $SPARK_HOME/bin && \
      ./spark-class org.apache.spark.deploy.worker.Worker \
        --webui-port $SPARK_WORKER_WEBUI_PORT \
        $SPARK_MASTER \
        >> $SPARK_WORKER_LOG
    ;;
  
  "submit")
    echo "SPARK SUBMIT"
    # Add logic for Spark submit if needed
    ;;
  
  *)
    echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, submit"
    ;;
esac
