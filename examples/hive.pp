

# == Class analytics::hive::server
#
# Installs and configures CDH4 Hive server.
# This requires that a MySQL server is running
# on this node.  This will create the hive
# MySQL database and user.
#
class analytics::hive::server {
	require analytics::packages::mysql_server, analytics::packages::mysql_java

	# symlink the mysql.jar into /var/lib/hive/lib
	file { "/usr/lib/hive/lib/mysql.jar":
		ensure  => "/usr/share/java/mysql.jar",
		require => [Package["libmysql-java"], Package["hive-metastore"], Package["hive-server"]],
	}

	$hive_db_name    = "hive_metastore"
	$hive_db_user    = "hive"
	# TODO: put this in private puppet repo
	$hive_db_pass    = "nonya"

	# hive is going to need an hive database and user.
	exec { "hive_mysql_create_database":
		command => "/usr/bin/mysql -e \"CREATE DATABASE $hive_db_name; USE $hive_db_name; SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.8.0.mysql.sql;\"",
		unless  => "/usr/bin/mysql -e 'SHOW DATABASES' | /bin/grep -q $hive_db_name",
		user    => "root",
	}
	exec { "hive_mysql_create_user":
		command => "/usr/bin/mysql -e \"CREATE USER '$hive_db_user'@'localhost' IDENTIFIED BY '$hive_db_pass'; CREATE USER '$hive_db_user'@'127.0.0.1' IDENTIFIED BY '$hive_db_pass'; GRANT ALL PRIVILEGES ON $hive_db_name.* TO '$hive_db_user'@'localhost' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON $hive_db_name.* TO '$hive_db_user'@'127.0.0.1' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
		unless  => "/usr/bin/mysql -e \"SHOW GRANTS FOR '$hive_db_user'@'127.0.0.1'\" | grep -q \"TO '$hive_db_user'\"",
		user    => "root",
	}

	class { "cdh4::hive::server":
		jdbc_driver   => "com.mysql.jdbc.Driver",
		jdbc_url      => "jdbc:mysql://localhost:3306/$hive_db_name",
		jdbc_username => "$hive_db_user",
		jdbc_password => "$hive_db_pass",
		require       => [File["/usr/lib/hive/lib/mysql.jar"], Exec["hive_mysql_create_database"], Exec["hive_mysql_create_user"]],
		subscribe     => [Exec["hive_mysql_create_database"], Exec["hive_mysql_create_user"]]
	}
}
