# == Class cdh4::hue
#
# Installs hue, sets up the hue.ini file
# and ensures that hue server is running.
# This requires that cdh4::hadoop::config is included.
#
class cdh4::hue {
	include cdh4::hue::install,
		cdh4::hue::config,
		cdh4::hue::service
}
