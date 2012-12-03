# == Class cdh4::oozie::server::install
#
class cdh4::oozie::server::config(
	$jdbc_driver,
	$jdbc_url,
	$jdbc_database,
	$jdbc_username,
	$jdbc_password,
	$authorization_service_security_enabled = true)
{
	file { "/etc/oozie/conf/oozie-env.sh":
		content => template("cdh4/oozie/oozie-env.sh.erb"),
		require => Package["oozie"],
	}

	file { "/etc/oozie/conf/oozie-site.xml":
		content => template("cdh4/oozie/oozie-site.xml.erb"),
		require => Package["oozie"],
	}
}
