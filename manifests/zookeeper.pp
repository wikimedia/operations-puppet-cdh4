# == cdh4::zookeeper
# Installs zookeeper-server and zookeeper client
# (Does not manage zoo.cfg or zookeeper-server service.)
class cdh4::zookeeper {
  include cdh4::zookeeper::install
}
