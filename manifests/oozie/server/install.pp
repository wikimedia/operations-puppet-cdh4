# == Class cdh4::oozie::server::install
#
class cdh4::oozie::server::install {
	package { "oozie":
		ensure => installed,
	}

	# Extract and install Oozie ShareLib into Hadoop.
	# This puppet module only supports YARN.
	# TODO:  Write generic hadoop::fs and hadoop::file
	# puppet resource types and uses these.
	exec { "Oozie_ShareLib_install":
		path    => "/bin:/usr/bin",
		command => "mkdir /tmp/ooziesharelib && \
			cd /tmp/ooziesharelib    && \
			tar xzf /usr/lib/oozie/oozie-sharelib-yarn.tar.gz      && \
			sudo -u hdfs hadoop fs -mkdir /user/oozie              && \
			sudo -u hdfs hadoop fs -chown oozie:hadoop /user/oozie && \
			sudo -u oozie hadoop fs -put share /user/oozie/share   && \
			cd /root && sudo rm -rf /tmp/ooziesharelib",
		unless => "hadoop fs -ls /user/oozie/share 2&>1 /dev/null",
	}
}
