# == Class cdh4::zookeeper::service
#
class cdh4::zookeeper::service {
	service { "zookeeper-server":
		ensure     => running,
		require    => Package["zookeeper-server"],
		hasrestart => true,
		hasstatus  => true,
		subscribe  => Class["cdh4::zookeeper::config"],
	}
}
