# build from hadoop-base:3.2.1
# that we built before using docker build -t hadoop-base:3.2.1 .
FROM hadoop-base:3.3.6

# # Add Hadoop configuration files
# ADD ../conf/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
# ADD ../conf/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

# Replace with this:
ENV HADOOP_HOME=/opt/hadoop

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
