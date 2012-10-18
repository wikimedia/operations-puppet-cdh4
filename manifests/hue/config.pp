# == Class cdh4::hue::config
#
# Installs hue.ini.erb.
# requires that cdh4::hadoop::config is included.
#
class cdh4::hue::config($secret_key = undef) {
	file { "/etc/hue/hue.ini":
		content => template("cdh4/hue/hue.ini.erb"),
		owner   => "root",
		mode    => "755",
	}
}
