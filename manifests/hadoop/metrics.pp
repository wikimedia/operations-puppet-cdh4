# == Class cdh4::hadoop::metrics
#
# Configures hadoop-metrics2.properties.
# Currently this only supports Ganglia31+
#
# Note that this does not notify any Hadoop services, so
# if there are changes, you will need to restart the Hadoop
# services yourself.  This class is not included by any
# of the other abstracted classes, so you will have to include
# this manually if you want Ganglia monitoring configured.
#
# == Parameters
# $ganglia_hosts - array of Ganglia hosts to send metrics to.
#
class cdh4::hadoop::metrics($ganglia_hosts = ['localhost:8469']) {
	file { "$cdh4::hadoop::config::config_directory/hadoop-metrics2.properties":
		content => template("cdh4/hadoop/hadoop-metrics2.properties.erb"),
		require => Class["cdh4::hadoop::config"],
	}
}