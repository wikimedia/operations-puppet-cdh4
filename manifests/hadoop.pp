
# == Class cdh4::hadoop
#
# Ensures that hadoop client packages are installed.
# All hadoop nodes require this class.
class cdh4::hadoop {
  include cdh4::hadoop::install::client
}

# == Class cdh4::hadoop::master
#
# The Hadoop Master is the NameNode,  ResourceManager, and HistoryServer.
# This ensures that the proper packages are installed, and that
# the services are running.
class cdh4::hadoop::master inherits cdh4::hadoop {
	include cdh4::hadoop::service::namenode
	include cdh4::hadoop::service::resourcemanager
	include cdh4::hadoop::service::historyserver

	# TODO:  Do we need this on master?
	# cdh4::hadoop::service::proxyserver
}


# == Class cdh4::hadoop::worker
#
# A Hadoop worker node is the DataNode and NodeManager.
class cdh4::hadoop::worker($mapreduce_framework_name = 'yarn') inherits cdh4::hadoop {
	include cdh4::hadoop::service::datanode
	include cdh4::hadoop::service::nodemanager
}