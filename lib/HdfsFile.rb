require 'time'
require 'puppet/application'
require 'puppet/util/symbolic_file_mode'

module Hdfs
  class FileNotFoundException < Exception
  end
  
  class File
    def self.chmod(mode, file_name)
      raise Hdfs::FileNotFoundException.new("The file '#{file_name}' does not exist in HDFS.") unless Hdfs.exists?(file_name)
      Hdfs.fs(:chmod, file_name, mode)
    end
  end
  
  class Stat
    attr_accessor :file_name, :mode, :owner, :group
    attr_reader :mtime, :size, :blksize, :replication_factor
  
  
    def initialize(file_name)
      raise Hdfs::FileNotFoundException.new("The file '#{file_name}' does not exist in HDFS.") unless Hdfs.exists?(file_name)

      @file_name = file_name
      # get data from hadoop fs -stat
      sync_from_stat Hdfs.fs(:stat, @file_name, '"%b %n %o %r %y"')
      # get data from hadoop fs -ls
      sync_from_ls   Hdfs.fs(:ls, @file_name).split("\n")[1]
    end
  
    def sync_from_stat(str)
        (@size, name, @blksize, @replication_factor, date, time) = str.split(' ')
        @mtime = Time.parse("#{date} #{time}")
    end
  
    def sync_from_ls(str)
      (@mode_string, replication_factor, @owner, @group, blksize, date, time, @file_name) = str.split(' ')
      @mode = mode_to_octal_string(@mode_string)
    end
  
    def to_s
      # instance_variables.collect{ |v| instance_variable_get(v)}.join("\t")
      "#{@mode}(#{@mode_string})\t#{@owner}\t#{@group}\t#{@size}\t#{@blksize}\t#{@replication_factor}\t#{@mtime}\t#{@file_name} "
    end
    
    
    
    # Since we can't get int modes from hadoop fs,
    # this method can convert string forms of modes to octal strings.
    def mode_to_octal_string(mode_string)
      # not dealing with extra bits of special perms, only rwx.
      octal_string = ''
      mode = [
        mode_string.slice(1,3),
        mode_string.slice(4,3),
        mode_string.slice(7,3),
      ]

      mode.each_index do |i|
        octal = 0
        octal |= 4 unless mode[i][0,1] == '-'
        octal |= 2 unless mode[i][1,1] == '-'
        octal |= 1 unless mode[i][2,1] == '-'
        # mode_int |= (octal << (6-(i*3)))
        octal_string += octal.to_s(8)
      end
      octal_string
    end

    def Hdfs.exists?(file)
      system "hadoop fs -test -e #{file}"
    end

    def Hdfs.fs(subcommand, file_name, args='')
      command = "hadoop fs -#{subcommand} #{args} #{file_name}"
      puts command
      return `#{command}`
    end
    
  end
end

# test 
file = Hdfs::Stat.new(ARGV[0])
puts file
Hdfs::File.chmod("775", ARGV[0])
file = Hdfs::Stat.new(ARGV[0])
puts file