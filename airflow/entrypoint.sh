#!/usr/bin/env bash

# Number of retry attempts for service readiness
TRY_LOOP="20"

# Global defaults and environment setup
: "${AIRFLOW_HOME:="/usr/local/airflow"}"
: "${AIRFLOW__CORE__FERNET_KEY:=${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")}}"
: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-CeleryExecutor}}"

# Configure to load DAG examples
if [[ -z "$AIRFLOW__CORE__LOAD_EXAMPLES" && "${LOAD_EX:=n}" == "n" ]]; then
  AIRFLOW__CORE__LOAD_EXAMPLES=False
fi

export \
  AIRFLOW_HOME \
  AIRFLOW__CORE__EXECUTOR \
  AIRFLOW__CORE__FERNET_KEY \
  AIRFLOW__CORE__LOAD_EXAMPLES

# Check if requirements.txt is present and install custom Python packages
if [ -e "/requirements.txt" ]; then
  echo "Installing custom Python packages from requirements.txt"
  pip install --user -r /requirements.txt
fi

# Exponential backoff function for service readiness
wait_for_port() {
  local name="$1"
  local host="$2"
  local port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j + 1))
    if [ $j -ge $TRY_LOOP ]; then
      echo "$(date) - $host:$port is not reachable after $TRY_LOOP attempts, exiting"
      exit 1
    fi
    echo "$(date) - Waiting for $name ($host:$port)... Attempt $j/$TRY_LOOP"
    sleep 5
  done
}

# If the executor is not SequentialExecutor, ensure PostgreSQL is ready
if [ "$AIRFLOW__CORE__EXECUTOR" != "SequentialExecutor" ]; then
  # Check if SQLAlchemy connection is set, otherwise set default values
  if [ -z "$AIRFLOW__CORE__SQL_ALCHEMY_CONN" ]; then
    : "${POSTGRES_HOST:="postgres"}"
    : "${POSTGRES_PORT:="5432"}"
    : "${POSTGRES_USER:="airflow"}"
    : "${POSTGRES_PASSWORD:="airflow"}"
    : "${POSTGRES_DB:="airflow"}"
    
    AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
    export AIRFLOW__CORE__SQL_ALCHEMY_CONN
    
    # For CeleryExecutor, ensure the result backend is set
    if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]; then
      AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
      export AIRFLOW__CELERY__RESULT_BACKEND
    fi
  else
    # Derive useful variables from SQLAlchemy connection
    POSTGRES_ENDPOINT=$(echo "$AIRFLOW__CORE__SQL_ALCHEMY_CONN" | cut -d '/' -f3 | sed -e 's,.*@,,')
    POSTGRES_HOST=$(echo -n "$POSTGRES_ENDPOINT" | cut -d ':' -f1)
    POSTGRES_PORT=$(echo -n "$POSTGRES_ENDPOINT" | cut -d ':' -f2)
  fi

  # Wait for PostgreSQL to be ready
  wait_for_port "Postgres" "$POSTGRES_HOST" "$POSTGRES_PORT"
fi

# CeleryExecutor requires a broker, typically Redis
if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]; then
  if [ -z "$AIRFLOW__CELERY__BROKER_URL" ]; then
    : "${REDIS_HOST:="redis"}"
    : "${REDIS_PORT:="6379"}"
    
    AIRFLOW__CELERY__BROKER_URL="redis://$REDIS_HOST:$REDIS_PORT"
    export AIRFLOW__CELERY__BROKER_URL
  fi
  
  # Wait for Redis to be ready
  wait_for_port "Redis" "$REDIS_HOST" "$REDIS_PORT"
fi

# Case statement to handle different commands for Airflow
case "$1" in
  webserver)
    # Start the Airflow webserver
    airflow db migrate
    if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ] || [ "$AIRFLOW__CORE__EXECUTOR" = "SequentialExecutor" ]; then
      airflow scheduler &
    fi
    exec airflow webserver
    ;;
  scheduler)
    # Start the scheduler
    exec airflow scheduler
    ;;
  flower)
    # Start Flower for monitoring
    exec airflow flower
    ;;
  triggerer)
    # Start the triggerer
    exec airflow triggerer
    ;;
  cli)
    # Start the CLI
    exec bash
    ;;
  worker)
    # Start a Celery worker
    exec airflow worker
    ;;
  *)
    # If the command is not recognized, run it as-is
    exec "$@"
    ;;
esac
