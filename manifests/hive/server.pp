# == Class cdh4::hive::service
#
# TODO: Seperate out hive-server and hive-metastore.
class cdh4::hive::server (
	$jdbc_driver                 = 'org.apache.derby.jdbc.EmbeddedDriver',
	$jdbc_url                    = 'jdbc:derby:;databaseName=/var/lib/hive/metastore/metastore_db;create=true',
	$jdbc_username               = '',
	$jdbc_password               = '',
	$exec_parallel_thread_number = 8,  # set this to 0 to disable hive.exec.parallel
	$optimize_skewjoin           = false,
	$skewjoin_key                = 10000,
	$skewjoin_mapjoin_map_tasks  = 10000,
	$stats_enabled               = false,
	$stats_dbclass               = "jdbc:derby",
	$stats_jdbcdriver            = "org.apache.derby.jdbc.EmbeddedDriver",
	$stats_dbconnectionstring    = "jdbc:derby:;databaseName=TempStatsStore;create=true")
{
	class { "cdh4::hive::server::install":
		require => Class["cdh4::hive::client::install"],
	}

	class { "cdh4::hive::server::config":
		jdbc_driver                 => $jdbc_driver,
		jdbc_url                    => $jdbc_url,
		jdbc_username               => $jdbc_username,
		jdbc_password               => $jdbc_password,
		exec_parallel_thread_number => $exec_parallel_thread_number,
		optimize_skewjoin           => $optimize_skewjoin,
		skewjoin_key                => $skewjoin_key,
		skewjoin_mapjoin_map_tasks  => $skewjoin_mapjoin_map_tasks,
		stats_enabled               => $stats_enabled,
		stats_dbclass               => $stats_dbclass,
		stats_jdbcdriver            => $stats_jdbcdriver,
		stats_dbconnectionstring    => $stats_dbconnectionstring,
		require                     => Class["cdh4::hive::server::install"],
	}

	# manage hive-metastore and hive-server2 services
	include cdh4::hive::server::service
}