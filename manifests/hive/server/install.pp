# == Class cdh4::hive::server::install
#
class cdh4::hive::server::install {
	package { "hive-metastore": 
		ensure => installed,
	}
	package { "hive-server2":
		ensure => "installed",
		alias  => "hive-server",
	}

	# make sure /user/hive/warehouse exists and has the correct permissions
	# TODO:  Write generic hadoop::fs and hadoop::file
	# puppet resource types and uses these.
	exec { "hive_hdfs_warehouse_directory":
		path    => "/bin:/usr/bin",
		command => "hadoop fs -mkdir /user/hive/warehouse        && \
			hadoop fs -chown hive:hadoop /user/hive              && \
			hadoop fs -chown hive:hadoop /user/hive/warehouse    && \
			hadoop fs -chmod 1777        /user/hive/warehouse",
		# don't run this command if /user/oozie/share already exists in HDFS.
		unless  => "hadoop fs -ls -d /user/hive/warehouse | grep -q /user/hive/warehouse",
		user    => "hdfs",
		require => [Package["hive"], Class["cdh4::hadoop"]],
	}
}
