# == Class cdh4::hive::server::config
#
class cdh4::hive::server::config($jdbc_driver, $jdbc_url, $jdbc_username, $jdbc_password)
{
	file { "/etc/hive/conf/hive-site.xml":
		content => template("cdh4/hive/hive-site.xml.erb"),
		require => Package["hive"],
	}
}
