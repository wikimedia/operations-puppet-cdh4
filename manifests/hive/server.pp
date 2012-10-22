# == Class cdh4::hive::service
#
# TODO: Seperate out hive-server and hive-metastore.
class cdh4::hive::server (
	$jdbc_driver   = 'org.apache.derby.jdbc.EmbeddedDriver',
	$jdbc_url      = 'jdbc:derby:;databaseName=/var/lib/hive/metastore/metastore_db;create=true',
	$jdbc_username = '',
	$jdbc_password = '')
{
	class { "cdh4::hive::server::install":
		require => Class["cdh4::hive::client::install"],
	}

	class { "cdh4::hive::server::config":
		jdbc_driver   => $jdbc_driver,
		jdbc_url      => $jdbc_url,
		jdbc_username => $jdbc_username,
		jdbc_password => $jdbc_password,
		require       => Class["cdh4::hive::server::install"],
	}

	# manage hive-metastore and hive-server2 services
	include cdh4::hive::server::service
}