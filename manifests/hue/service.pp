# == Class cdh4::hue::service
# 
# Ensures that the hue service service is running.
#
class cdh4::hue::service {
	require cdh4::hue::install
	require cdh4::hue::config

	service { "hue": 
		ensure    => "running",
		enable    => true,
		subscribe => File["/etc/hue/hue.ini"]
	}
}
