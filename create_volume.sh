#!/bin/bash

sudo mkdir -p /bigdata/hadoop_namenode
sudo mkdir -p /bigdata/hadoop_datanode1
sudo mkdir -p /bigdata/hadoop_datanode2
sudo mkdir -p /bigdata/hadoop_datanode3
sudo mkdir -p /bigdata/hadoop_namenager_local
sudo mkdir -p /bigdata/hadoop_namenager_logs
sudo mkdir -p /bigdata/hadoop_historyserver
sudo mkdir -p /bigdata/airflow/output
sudo mkdir -p /bigdata/airflow/plugins
sudo mkdir -p /bigdata/airflow/logs
sudo mkdir -p /bigdata/postgres/data
sudo mkdir -p /bigdata/postgres/pgadmin_data
sudo mkdir -p /bigdata/spark/apps
sudo mkdir -p /bigdata/spark/data
sudo mkdir -p /bigdata/redis/data

sudo chown root -R /bigdata/
sudo chmod 777 -R /bigdata/