Puppet module to install and manage components of Cloudera's Distribution 4 (CDH4) for Apache Hadoop.

_NOTE_: This module currently only supports YARN, and not MapReduce version 1.


# Description
Installs HDFS, YARN MapReduce, hive, hbase, pig, sqoop and zookeeper.
Note that, in order for this module to work, you will have to ensure that:
* SUN jre version 6 or greater is installed
* Your package manager is configured with a repository containing the
  Cloudera 4 packages, OR you manually include cdh4::apt_source.

The cdh4::hadoop::master and cdh4::hadoop::worker classes will
manage hadoop services.


# Usage

## For all hadoop nodes:
<pre>
include cdh4
class { "cdh4::hadoop::config":
	namenode_hostname => "namenode.hostname.org",
	mounts            => [
	    "/var/lib/hadoop/data/a",
	    "/var/lib/hadoop/data/b",
	    "/var/lib/hadoop/data/c"
	],
	dfs_name_dir      => ["/var/lib/hadoop/name", "/mnt/hadoop_name"],
}
</pre>

## For your Hadoop master NameNode:
<pre>
include cdh4::hadoop::master
</pre>

## For your Hadoop worker DataNodes:
include cdh4::hadoop::worker
</pre>

