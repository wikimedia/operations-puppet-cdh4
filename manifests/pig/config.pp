
class cdh4::pig::config {
  file { "/etc/pig/pig.properties":
    source  => "puppet:///modules/cdh4/pig.properties",
    require => Class["cdh4::pig::install"],
    owner   => "root",
    mode    => "755",
  }
}
