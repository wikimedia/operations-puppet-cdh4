# == Class cdh4::hue
#
# Installs hue, sets up the hue.ini file
# and ensures that hue server is running.
# This requires that cdh4::hadoop::config is included.
#
class cdh4::hue($secret_key = undef) {
	include cdh4::hue::install

	# config needs hue installed and hadoop config defined.
	class { "cdh4::hue::config":
		secret_key => $secret_key,
		require => [Class["cdh4::hue::install"], Class["cdh4::hadoop::config"]],
	}

	# The hue service subscribes to the hue config file.
	class { "cdh4::hue::service": 
		require => Class["cdh4::hue::config"],
	}
}
