# == Class cdh4::oozie::server::install
#
class cdh4::oozie::server::config($jdbc_driver, $jdbc_url, $jdbc_username, $jdbc_password)
{
	file { "/etc/oozie/oozie-env.sh":
		content => template("cdh4/oozie/oozie-env.sh.erb"),
		require => Package["oozie"],
	}

	file { "/etc/oozie/oozie-site.xml":
		content => template("cdh4/oozie/oozie-site.xml.erb"),
		require => Package["oozie"],
	}
}
