# Set the Hadoop home directory
export HADOOP_HOME=/opt/hadoop

# Set the Hive home directory
export HIVE_HOME=/opt/hive

# Configure Hive heap size
export HIVE_HEAPSIZE=512

# Configure the Hadoop classpath
export HADOOP_CLASSPATH=$HADOOP_HOME/share/hadoop/tools/lib/*:$HADOOP_CLASSPATH

# Set other environment variables as needed
