# See analytics.pp for site specific
# classes and configuration of CDH4

node hadoop_master {
	include analytics::master
}

node /hadoop_worker[0-9][0-9]/ {
	include analytics::worker
}

node zookeeper1,zookeeper2,zookeeper3 {
	include analytics::zookeeper
}