# 

class { '::cdh4::hadoop':
  namenode_hostname    => 'localhost',
  dfs_name_dir         => '/var/lib/hadoop/name',
}

# resourcemanager requires namenode
include cdh4::hadoop::namenode
include cdh4::hadoop::resourcemanager
