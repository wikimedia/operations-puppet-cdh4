class analytics_base {
	require cdh4::apt_source
	# install common cdh4 packages and config
	include cdh4 
	# hadoop config is common to all nodes
	include analytics::hadoop::config
}



class analytics::master inherits analytics_base {
	# hadoop master (namenode, etc.)
	include cdh4::hadoop::master
	# oozier server
	include analytics::oozie::server
	# hive metastore and hive server
	include analytics::hive::server

	# hue server
	class { "cdh4::hue":
		secret_key => "nonya",
		require    => Class["cdh4::oozie::server"],
	}
}

class analytics::worker inherits analytics::base {
	# hadoop worker (datanode, etc.)
	include cdh4::hadoop::worker
}






class analytics::hadoop::config {
	$namenode_hostname        = "hadoop_master.nonya.org"
	$hadoop_base_directory    = "/var/lib/hadoop"
	$hadoop_name_directory    = "$hadoop_base_directory/name"
	$hadoop_data_directory    = "$hadoop_base_directory/data"
	
	$hadoop_mounts = [
		"$hadoop_data_directory/e",
		"$hadoop_data_directory/f",
		"$hadoop_data_directory/g",
		"$hadoop_data_directory/h",
		"$hadoop_data_directory/i",
		"$hadoop_data_directory/j",
	]

	class { "cdh4::hadoop::config":
		namenode_hostname    => $namenode_hostname,
		mounts               => $hadoop_mounts,
		dfs_name_dir         => [$hadoop_name_directory],
		dfs_block_size       => 268435456,  # 256 MB
		map_tasks_maximum    => ($processorcount - 2) / 2,
		reduce_tasks_maximum => ($processorcount - 2) / 2,
		map_memory_mb        => 1536,
		io_file_buffer_size  => 131072,
		reduce_parallel_copies => 10,
		mapreduce_job_reuse_jvm_num_tasks => -1,
		mapreduce_child_java_opts => "-Xmx512M",
	}
}


# == Class analytics::packages::mysql_java
#
# Ensures that libmysql-java (Debian package)
# is installed.  This is the JDBC MySQL connector.
class analytics::packages::mysql_java {
	package { "libmysql-java":
		ensure => "installed",
	}
}

class analytics::packages::mysql_server {
	package { "mysql-server":
		ensure => "installed",
	}
}


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



# == Class analytics::hive::server
#
# Installs and configures CDH4 Hive server.
# This requires that a MySQL server is running
# on this node.  This will create the hive
# MySQL database and user.
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