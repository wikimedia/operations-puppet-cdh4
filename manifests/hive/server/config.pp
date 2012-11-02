# == Class cdh4::hive::server::config
#
class cdh4::hive::server::config(
	$jdbc_driver,
	$jdbc_url,
	$jdbc_username,
	$jdbc_password,
	$exec_parallel_thread_number = 8,  # set this to 0 to disable hive.exec.parallel
	$optimize_skewjoin           = false,
	$skewjoin_key                = 10000,
	$skewjoin_mapjoin_map_tasks  = 10000,
	$stats_enabled               = false,
	$stats_dbclass               = "jdbc:derby",
	$stats_jdbcdriver            = "org.apache.derby.jdbc.EmbeddedDriver",
	$stats_dbconnectionstring    = "jdbc:derby:;databaseName=TempStatsStore;create=true")
{
	# bring this into a local variable so we can
	# tests for its definition in the hive-site.xml.erb template.
	$zookeeper_hosts = $cdh4::zookeeper::config::zookeeper_hosts

	file { "/etc/hive/conf/hive-site.xml":
		content => template("cdh4/hive/hive-site.xml.erb"),
		require => Package["hive"],
	}
}
