# == Class cdh4::hbase
#
# Installs HBase packages needed for server and region-servers
#
class cdh4::hbase(
  $root_dir         = $::cdh4::hbase::defaults::root_dir,
  $config_directory = $::cdh4::hbase::defaults::config_directory,
  $master_domain    = $::cdh4::hbase::defaults::master_domain,
  $zookeeper_master = $::cdh4::hbase::defaults::zookeeper_master,
) inherits cdh4::hbase::defaults 
{
  package { 'hbase':
    ensure => 'installed',
  }

  file { "${config_directory}/hbase-site.xml":
    content => template('cdh4/hbase/hbase-site.xml.erb'),
  }
}
