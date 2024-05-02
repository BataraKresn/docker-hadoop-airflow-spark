# build from hadoop-base:3.2.1
# that we built before using docker build -t hadoop-base:3.2.1 .
FROM hadoop-base:3.3.6

# Add Hadoop configuration files
# ADD ../conf/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
# ADD ../conf/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml

# Other Dockerfile settings
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

# Healthcheck and script setup
HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1
ADD run.sh /run.sh
RUN chmod a+x /run.sh

# Expose ports and set the command to run
EXPOSE 9870
CMD ["/run.sh"]
