#!/bin/bash

# Check if the network already exists
if ! docker network inspect hadoop_network &>/dev/null; then
  # Create new network if it doesn't exist
  docker network create hadoop_network
fi

# build docker image with image name hadoop-base:3.3.6
docker build -t hadoop-base:3.3.6 -f Dockerfile-hadoop .
if [ $? -ne 0 ]; then
  echo "Error building hadoop-base image" >&2
  exit 1
fi

# Run Spark Cluster
if [[ "$PWD" != "spark" ]]; then
  cd spark && ./start-cluster.sh && cd ..
fi

# running image to container, -d to run it in daemon mode
docker compose -f docker-compose-hadoop.yml up -d

# cd postgres
# docker build -t postgres:10.3 -f Dockerfile-postgres .
# cd ..

# Run Airflow Cluster
if [[ "$PWD" != "airflow" ]]; then
  cd airflow && ./run_airflow.sh && cd ..
fi

# docker compose -f docker-compose-airflow.yml up -d
# docker compose -f docker-compose-airflow.yml up -d

echo "Current dir is $PWD"
