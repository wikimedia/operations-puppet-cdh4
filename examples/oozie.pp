

# == Class analytics::oozie::server
#
# Installs and configues CDH4 Oozie server.
# This requires that a MySQL server is running
# on this node.  This will create the oozie
# MySQL database and user.
class analytics::oozie::server {
	require analytics::packages::mysql_server, analytics::packages::mysql_java

	# symlink the mysql.jar into /var/lib/oozie
	file { "/var/lib/oozie/mysql.jar":
		ensure  => "/usr/share/java/mysql.jar",
		require => Package["libmysql-java"]
	}

	$oozie_db_name    = "oozie"
	$oozie_db_user    = "oozie"
	# TODO: put this in private puppet repo
	$oozie_db_pass    = "nonya"
	# oozie is going to need an oozie database and user.
	exec { "oozie_mysql_create_database":
		command => "/usr/bin/mysql -e \"CREATE DATABASE $oozie_db_name; GRANT ALL PRIVILEGES ON $oozie_db_name.* TO '$oozie_db_user'@'localhost' IDENTIFIED BY '$oozie_db_pass'; GRANT ALL PRIVILEGES ON $oozie_db_name.* TO '$oozie_db_user'@'%' IDENTIFIED BY '$oozie_db_pass';\"",
		unless  => "/usr/bin/mysql -e 'SHOW DATABASES' | /bin/grep -q $oozie_db_name",
		user    => 'root',
	}

	class { "cdh4::oozie::server":
		jdbc_driver       => "com.mysql.jdbc.Driver",
		jdbc_url          => "jdbc:mysql://localhost:3306/$oozie_db_name",
		jdbc_database     => "$oozie_db_name",
		jdbc_username     => "$oozie_db_user",
		jdbc_password     => "$oozie_db_pass",
		subscribe         => Exec["oozie_mysql_create_database"],
		require           => [File["/var/lib/oozie/mysql.jar"], Exec["oozie_mysql_create_database"]],
	}
}
