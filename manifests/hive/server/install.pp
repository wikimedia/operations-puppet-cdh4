# == Class cdh4::hive::server::install
#
class cdh4::hive::server::install {
	package { "hive-metastore": 
		ensure => installed,
	}
	package { "hive-server2":
		ensure => "installed",
		alias  => "hive-server",
	}
}
