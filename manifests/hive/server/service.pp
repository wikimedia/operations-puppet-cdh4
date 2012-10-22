# == Class cdh4::hive::server::service
#
class cdh4::hive::server::service {
	service { "hive-metastore":
		ensure     => running,
		require    => [Package["hive-metastore"], Package["hive-server2"]],
		hasrestart => true,
		hasstatus  => true,
		subscribe  => Class["cdh4::hive::server::config"],
	}
	
	service { "hive-server2":
		ensure     => running,
		require    => [Package["hive-metastore"], Package["hive-server2"]],
		hasrestart => true,
		hasstatus  => true,
		subscribe  => Class["cdh4::hive::server::config"],
	}
}
