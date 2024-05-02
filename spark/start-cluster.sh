#!/bin/bash

docker build --no-cache -t spark-base:3.5.0 .
docker compose up -d
