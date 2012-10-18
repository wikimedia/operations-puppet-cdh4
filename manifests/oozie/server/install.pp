# == Class cdh4::oozie::server::install
#
class cdh4::oozie::server::install {
	package { "oozie":
		ensure => installed,
	}
}
