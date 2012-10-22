# == Class cdh4::hive::client::install
#
class cdh4::hive::client::install {
	package { "hive": ensure => installed }
}
