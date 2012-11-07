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
# $jmxremote_port     Set this to enable remote JMX connections.  Set to false to disable.  Default: 9998
#
class cdh4::zookeeper::config(
	$data_dir          = "/var/lib/zookeeper",
	$zookeeper_hosts   = undef,
	$jmxremote_port   = 9998)
{
	file { "/etc/zookeeper/conf/zoo.cfg":
		content => template("cdh4/zookeeper/zoo.cfg.erb"),
		require => Package["zookeeper-server"],
	}

	# If jmxremote_port is false, zookeeper-env.sh
	# won't have any content.  Might as well not render it.
	file { "/etc/zookeeper/conf/zookeeper-env.sh":
		content => template("cdh4/zookeeper/zookeeper-env.sh.erb"),
		require => Package["zookeeper-server"],
		ensure  => $jmxremote_port ? {
			false   => "absent",
			default => "present"
		}
	}
}