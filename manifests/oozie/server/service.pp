# == Class cdh4::oozie::server::service
#
class cdh4::oozie::server::service {
	service { "oozie":
		ensure     => running,
		require    => Package["oozie"],
		hasrestart => true,
		hasstatus  => true,
		subscribe  => Class["cdh4::oozie::server::config"],
	}
}
