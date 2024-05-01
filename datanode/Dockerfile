# build from hadoop-base:3.2.1
# that we built before using docker build -t hadoop-base:3.3.6 .
FROM hadoop-base:3.3.6

# Add Hadoop configuration files
# ADD hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
# ADD core-site.xml /opt/hadoop/etc/hadoop/core-site.xml

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864

CMD ["/run.sh"]