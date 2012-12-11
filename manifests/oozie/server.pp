# == Class cdh4::oozie::server
#
class cdh4::oozie::server(
	$jdbc_driver     = 'org.apache.derby.jdbc.EmbeddedDriver',
	$jdbc_url        = 'jdbc:derby:${oozie.data.dir}/${oozie.db.schema.name}-db;create=true',
	$jdbc_database   = 'oozie',
	$jdbc_username   = "sa",
	$jdbc_password   = " ",
	$smtp_host       = undef,
	$smtp_port       = 25,
	$smtp_from_email = undef,
	$smtp_username   = undef,
	$smtp_password   = undef,
	$authorization_service_security_enabled = true)
{
	include cdh4::oozie::server::install

	class { "cdh4::oozie::server::config": 
		jdbc_driver     => $jdbc_driver,
		jdbc_url        => $jdbc_url,
		jdbc_database   => $jdbc_database,
		jdbc_username   => $jdbc_username,
		jdbc_password   => $jdbc_password,
		smtp_host       => $smtp_host,
		smtp_port       => $smtp_port,
		smtp_from_email => $smtp_from_email,
		smtp_username   => $smtp_username,
		smtp_password   => $smtp_password,
		authorization_service_security_enabled => $authorization_service_security_enabled,
		require         => Class["cdh4::oozie::server::install"],
	}

	# Ensure that Catalina working directories exist.
	# Without these, oozie will log the error:
	# "The specified scratchDir is unusable: /usr/lib/oozie/oozie-server-0.20/work/Catalina/localhost/_"
	file { ["/usr/lib/oozie/oozie-server/work",
			"/usr/lib/oozie/oozie-server/work/Catalina",
			"/usr/lib/oozie/oozie-server/work/Catalina/localhost"]:
		ensure  => "directory",
		owner   => "root",
		group   => "root",
		mode    => 0755,
		require => Class["cdh4::oozie::server::install"],
	}
	file { ["/usr/lib/oozie/oozie-server/work/Catalina/localhost/_",
			"/usr/lib/oozie/oozie-server/work/Catalina/localhost/oozie"]:
		ensure  => "directory",
		owner   => "oozie",
		group   => "oozie",
		mode    => 0755,
		require => File["/usr/lib/oozie/oozie-server/work/Catalina/localhost"],
	}

	# ensure that oozie service is running
	class { "cdh4::oozie::server::service":
		require => [Class["cdh4::oozie::server::config"], File["/usr/lib/oozie/oozie-server/work/Catalina/localhost/oozie"]],
	}
}
