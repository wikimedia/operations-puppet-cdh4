# == Class cdh4::oozie::client::install
#
class cdh4::oozie::client::install {
	package { "oozie-client":
		ensure => installed,
	}
}
