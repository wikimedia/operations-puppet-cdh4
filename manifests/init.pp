
# == Class cdh4
#
# Installs common Cloudera / Hadoop packages.
class cdh4 {
	include hadoop
	include hbase
	include hive
	include zookeeper
	include pig
	include sqoop
	# include oozie
}


# == Class cdh4::apt_source
# 
# Configures an apt source list pointing at
# Cloudera's CDH4 apt repository.
# 
# This class is not included by default.  If
# you want to use Cloudera's apt repository,
# make sure you include this as a dependency (using before =>)
# you include other cdh4 classes.
class cdh4::apt_source {
	$operatingsystem_lowercase = inline_template("<%= operatingsystem.downcase %>")

	file { "/etc/apt/sources.list.d/cdh4.list":
		content => "deb [arch=${architecture}] http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh4 contrib\ndeb-src http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh4 contrib\n",
		mode    => 0444,
		ensure  => 'present',
	}
	
	if $hostname != 'analytics1001' {
		Exec {
			environment => "http_proxy=http://brewster.wikimedia.org:8080"
		}
	}

	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh/archive.key | /usr/bin/apt-key add -",
		subscribe => File["/etc/apt/sources.list.d/cdh4.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
	}

	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cdh4.list"], Exec["import_cloudera_apt_key"]],
	}
}
