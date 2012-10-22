
# == Class analytics::base
# Includes classes common to all CDH4 analytics nodes.
class analytics::base {
	require cdh4::apt_source
	# install common cdh4 packages and config
	include cdh4 
	# hadoop config is common to all nodes
	include analytics::hadoop::config
	# zookeeper config is common to all nodes
	include analytics::zookeeper::config
}


# == Class analytics::master
# Includes classes to run on a CDH4 master (NameNode, oozie, hive, hue, etc.)
class analytics::master inherits analytics::base {
	# hadoop master (namenode, etc.)
	include cdh4::hadoop::master
	# oozier server
	include analytics::oozie::server
	# hive metastore and hive server
	include analytics::hive::server

	# hue server
	class { "cdh4::hue":
		secret_key => "nonya",
		require    => Class["cdh4::oozie::server"],
	}
}

# == Class analytics::worker
# Includes classes for CDH4 Hadoop Workers (DataNode, etc.)
class analytics::worker inherits analytics::base {
	# hadoop worker (datanode, etc.)
	include cdh4::hadoop::worker
}

# == Class analytics::zookeeper
# Includes classes to set up a zookeeper server
class analytics::zookeeper inherits analytics::base {
	include analytics::zookeeper::server
}


# == Class analytics::packages::mysql_java
#
# Ensures that libmysql-java (Debian package)
# is installed.  This is the JDBC MySQL connector.
class analytics::packages::mysql_java {
	package { "libmysql-java":
		ensure => "installed",
	}
}

# == Class analytics::packages::mysql_java
# ensures that MySQL server is installed.
class analytics::packages::mysql_server {
	package { "mysql-server":
		ensure => "installed",
	}
}


