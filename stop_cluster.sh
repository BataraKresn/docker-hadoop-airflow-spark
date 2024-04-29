#!/bin/bash

# Stop Airflow
#docker compose -f docker-compose-airflow.yml down
docker compose -f docker-compose-airflow.yml down --remove-orphans

# Stop Hadoop
docker compose -f docker-compose-hadoop.yml down --remove-orphans

# Run Spark Cluster
if [[ "$PWD" != "spark" ]]; then
  cd spark && docker compose down && cd ..
fi

echo "All services stoped"
