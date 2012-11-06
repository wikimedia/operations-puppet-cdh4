# == Class cdh4::oozie::server::install
#
class cdh4::oozie::server::install {
	package { "oozie":
		ensure => installed,
	}

	# Extract and install Oozie ShareLib into HDFS.
	# This puppet module only supports YARN.
	# TODO:  Write generic hadoop::fs and hadoop::file
	# puppet resource types and uses these.
	exec { "Oozie_ShareLib_install":
		path    => "/bin:/usr/bin",
		command => "rm -rf /tmp/ooziesharelib; mkdir /tmp/ooziesharelib && \
			cd /tmp/ooziesharelib    && \
			tar xzf /usr/lib/oozie/oozie-sharelib-yarn.tar.gz      && \
			sudo -u hdfs hadoop fs -mkdir /user/oozie              && \
			sudo -u hdfs hadoop fs -chown oozie:hadoop /user/oozie && \
			sudo -u oozie hadoop fs -put share /user/oozie/share   && \
			cd /root && rm -rf /tmp/ooziesharelib",
		# don't run this command if /user/oozie/share already exists in HDFS.
		unless  => "hadoop fs -ls /user/oozie | grep -q /user/oozie/share",
		require => [Package["oozie"], Class["cdh4::hadoop"]],
	}
}
