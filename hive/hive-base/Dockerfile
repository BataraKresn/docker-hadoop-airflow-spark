FROM hadoop-base:3.3.6
LABEL maintainer="SAT"

ARG HIVE_VERSION
ENV HIVE_VERSION=${HIVE_VERSION:-3.1.2}
ENV HIVE_HOME=/opt/hive
ENV PATH=${HIVE_HOME}/bin:$PATH

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN apt-get update && apt-get install -y wget procps && \
	wget https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-42.1.4.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Spark should be compiled with Hive to be able to use it
# hive-site.xml should be copied to $SPARK_HOME/conf folder

COPY ./conf/hive-site.xml ${HIVE_HOME}/conf
COPY ./conf/hive-env.sh ${HIVE_HOME}/conf
COPY ./conf/ivysettings.xml ${HIVE_HOME}/conf

COPY ./entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 10000 
EXPOSE 10001
EXPOSE 10002

ENTRYPOINT [ "./entrypoint.sh" ]