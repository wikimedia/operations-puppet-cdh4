
# == Class cdh4
#
# Installs common Cloudera / Hadoop packages.
class cdh4 {
	include hadoop
	include hbase
	include hive
	include zookeeper
	include pig
	include sqoop
	include oozie
}
