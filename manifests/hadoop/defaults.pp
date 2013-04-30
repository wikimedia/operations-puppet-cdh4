# == Class cdh4::hadoop::defaults
# Default parameters for cdh4::hadoop configuration.
#
class cdh4::hadoop::defaults {
  $config_directory                  = '/etc/hadoop/conf'
  $datanode_mounts                   = undef
  $dfs_data_path                     = 'hdfs/dn'
  $yarn_local_path                   = 'yarn/local'
  $yarn_logs_path                    = 'yarn/logs'
  $dfs_block_size                    = 67108864 # 64MB default
  $enable_jmxremote                  = true
  $enable_webhdfs                    = true
  $enable_intermediate_compression   = true
  $enable_final_compession           = false
  $io_file_buffer_size               = undef
  $map_tasks_maximum                 = undef
  $reduce_tasks_maximum              = undef
  $reduce_parallel_copies            = undef
  $map_memory_mb                     = undef
  $mapreduce_job_reuse_jvm_num_tasks = undef
  $mapreduce_child_java_opts         = undef
  $use_yarn                          = true
}