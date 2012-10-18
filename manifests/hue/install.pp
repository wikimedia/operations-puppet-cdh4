# == Class cdh4::hue::install
#
# Installs hue and hue-server packages.
#
class cdh4::hue::install {
	package { ["hue", "hue-server"]: ensure => installed }
}
