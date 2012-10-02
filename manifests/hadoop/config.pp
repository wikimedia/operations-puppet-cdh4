# Class: cdh4::hadoop::config
#

#
# == Class cdh4::hadoop::config
#
# Installs the main Hadoop/HDFS config files.  This
# Will set Hadoop config files to run YARN (MapReduce 2).
#
# This assumes that your JBOD mount points are already
# formatted and mounted at the locations listed in $mounts.
# 
# dfs.datanode.data.dir will be set to each of {$mounts}/$data_path
# yarn.nodemanager.local-dirs will be set to each of {$mounts}/$yarn_local_path
# yarn.nodemanager.log-dirs will be set to each of {$mounts}/$yarn_logs_path
#
# == Parameters
#   $mounts            - array of JBOD mount points.  Hadoop datanode and mapreduce/yarn directories will be here.
#   $namenode_hostname - hostname of the namenode.  This will also be used as the hostname for the historyserver, proxyserver, and resourcemanager.
#   $dfs_name_dir      - full path to hadoop NameNode name directory.  This can be an array of paths or a single string path.
#   $config_directory  - path of the hadoop config directory.
#   $dfs_data_path     - path relative to JBOD mount point for HDFS data directories.
#   $yarn_local_path   - path relative to JBOD mount point for yarn local directories.
#   $yarn_logs_path    - path relative to JBOD mount point for yarn log directories.
#   $dfs_block_size    - HDFS block size in bytes.  Default 64MB.
#
# TODO:
#   - Change cluster (conf) name?  (use alternatives?)
#   - Manage each hadoop directory in mounts in puppet?
#   - Add parameters for historyserver, proxyserver, resourcemanager hostnames, etc.
class cdh4::hadoop::config(
	$mounts,
	$namenode_hostname,
	$dfs_name_dir,
	$config_directory = '/etc/hadoop/conf',
	$dfs_data_path    = "hdfs/dn",
	$yarn_local_path  = 'yarn/local',
	$yarn_logs_path   = 'yarn/logs',
	$dfs_block_size   = 67108864, # 64MB default
) {
	require cdh4::hadoop

	# TODO: set default map/reduce tasks
	# automatically based on node stats.
	file { "$config_directory/core-site.xml":
		content => template("cdh4/hadoop/core-site.xml.erb"),
	}

	file { "$config_directory/hdfs-site.xml":
		content => template("cdh4/hadoop/hdfs-site.xml.erb"),
	}

	file { "$config_directory/yarn-site.xml":
		content => template("cdh4/hadoop/yarn-site.xml.erb")
	}

	# only need this to set framework.name
	file { "$config_directory/mapred-site.xml":
		content => template("cdh4/hadoop/mapred-site.xml.erb")
	}
}
