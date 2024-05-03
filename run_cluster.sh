#!/bin/bash

# Check if the network already exists
if ! docker network inspect hadoop_network &>/dev/null; then
  # Create new network if it doesn't exist
  docker network create hadoop_network
fi

# --no-cache
# build docker image with image name hadoop-base:3.3.6
docker build --no-cache -t hadoop-base:3.3.6 -f Dockerfile-hadoop .

# running image to container, -d to run it in daemon mode
docker compose --no-cache -f docker-compose-hadoop.yml up -d

# cd postgres
# docker build -t postgres:10.3 -f Dockerfile-postgres .
# cd ..

# Run Airflow Cluster
if [[ "$PWD" != "airflow" ]]; then
  cd airflow && ./run_airflow.sh && cd ..
fi

# docker compose -f docker-compose-airflow.yml up -d
docker compose --no-cache -f docker-compose-airflow.yml up -d 

# Run Spark Cluster
if [[ "$PWD" != "spark" ]]; then
  cd spark && ./start-cluster.sh && cd ..
fi

echo "Current dir is $PWD"
