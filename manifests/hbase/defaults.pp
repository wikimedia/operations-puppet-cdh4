# == Class cdh4::hbase::defaults
# Default parameters for cdh4::hbase configuration.
#
class cdh4::hbase::defaults {
  $root_dir         = '/hbase'
  $config_directory = '/etc/hbase/conf'
  $master_domain    = undef
  $zookeeper_master = undef
}
