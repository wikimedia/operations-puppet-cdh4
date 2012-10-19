# == Class cdh4::oozie::server
#
class cdh4::oozie::server(
	$jdbc_driver   = 'org.apache.derby.jdbc.EmbeddedDriver',
	$jdbc_url      = 'jdbc:derby:${oozie.data.dir}/${oozie.db.schema.name}-db;create=true',
	$jdbc_database = 'oozie',
	$jdbc_username = "sa",
	$jdbc_password = " ")
{
	include cdh4::oozie::server::install

	class { "cdh4::oozie::server::config": 
		jdbc_driver   => $jdbc_driver,
		jdbc_url      => $jdbc_url,
		jdbc_database => $jdbc_database,
		jdbc_username => $jdbc_username,
		jdbc_password => $jdbc_password,
		require       => Class["cdh4::oozie::server::install"],
	}

	class { "cdh4::oozie::server::service":
		require       => Class["cdh4::oozie::server::config"],
	}
}
