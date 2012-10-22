# == Class cdh4::hive::server::config
#
class cdh4::hive::server::config($jdbc_driver, $jdbc_url, $jdbc_username, $jdbc_password)
{
	# bring this into a local variable so we can
	# tests for its definition in the hive-site.xml.erb template.
	$zookeeper_hosts = $cdh4::zookeeper::config::zookeeper_hosts

	file { "/etc/hive/conf/hive-site.xml":
		content => template("cdh4/hive/hive-site.xml.erb"),
		require => Package["hive"],
	}
}
