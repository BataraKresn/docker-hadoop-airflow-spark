FROM postgres:10.3

LABEL Description="This is the postgres DB used for bigdata cluster frameworks;E.g: Hive Metastore etc.." \
      Author="Semesta Arus <bigdata0124@gmail.com>"

ENV PGDATA /var/lib/postgresql/data/pgdata
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB postgres

# Copy custom pg_hba.conf file
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

ADD 01-postgres-init.sql  /docker-entrypoint-initdb.d/
ADD 02-hive-schema-2.3.0.postgres.sql  /docker-entrypoint-initdb.d/
ADD 03-hive-txn-schema-2.3.0.postgres.sql  /docker-entrypoint-initdb.d/

HEALTHCHECK CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1