# == Class cdh4::hue::service
# 
# Ensures that the hue service service is running.
#
class cdh4::hue::service {
	service { "hue": 
		ensure    => "running",
		enable    => true,
		subscribe => File["/etc/hue/hue.ini"],
		require   => Class["cdh4::hue::config"],
	}
}
