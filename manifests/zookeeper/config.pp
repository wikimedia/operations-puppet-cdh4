# == Class cdh4::zookeeper::config
#
# This class will infer the zookeeper myid from numbers
# in the nodes hostname.  This requires that all the nodes
# you are including this class on have numbers in their hostnames.
# This simplifies configuration, in that you don't have to
# manually pick a myid number for each of your zookeeper nodes.
#
# == Parameters
#
# $data_dir            ZooKeeper dataDir.  [default: /var/lib/zookeeper]
# $zookeeper_hosts     Array of zookeeper server hostnames.  Their myids will be inferred from the hostname.
#
class cdh4::zookeeper::config(
	$data_dir          = "/var/lib/zookeeper",
	$zookeeper_hosts   = undef)
{	
	file { "/etc/zookeeper/conf/zoo.cfg":
		content => template("cdh4/zookeeper/zoo.cfg.erb"),
		require => Package["zookeeper-server"],
	}
}