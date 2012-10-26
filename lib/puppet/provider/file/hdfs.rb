require '../../../HdfsFile'

Puppet::Type.type(:file).provide :hdfs do
  desc "Uses HDFS to manage file ownership and permissions."

  confine :feature => :hdfs

  # include Puppet::Util::POSIX
  # include Puppet::Util::Warnings

  require 'etc'
  
  def stat
    return @stat if defined? @stat
    
    begin
      @stat = Hdfs::Stat(resource[:path])
    rescue Hdfs::FileNotFoundException
      @stat = nil
    end
  end

  def mode
    if stat
      return stat.mode.to_s(8)
    else
      return :absent
    end
  end

  def mode=(value)
    begin
      Hdfs::File.chmod(value.to_i(8), resource[:path])
    rescue => detail
      error = Puppet::Error.new("failed to set mode #{mode} on #{resource[:path]}: #{detail.message}")
      error.set_backtrace detail.backtrace
      raise error
    end
  end

  # def owner=(should)
  #    # Set our method appropriately, depending on links.
  #    if resource[:links] == :manage
  #      method = :lchown
  #    else
  #      method = :chown
  #    end
  # 
  #    begin
  #      File.send(method, should, nil, resource[:path])
  #    rescue => detail
  #      raise Puppet::Error, "Failed to set owner to '#{should}': #{detail}"
  #    end
  #  end
  # 
  #  def group
  #    return :absent unless stat = resource.stat
  # 
  #    currentvalue = stat.gid
  # 
  #    # On OS X, files that are owned by -2 get returned as really
  #    # large GIDs instead of negative ones.  This isn't a Ruby bug,
  #    # it's an OS X bug, since it shows up in perl, too.
  #    if currentvalue > Puppet[:maximum_uid].to_i
  #      self.warning "Apparently using negative GID (#{currentvalue}) on a platform that does not consistently handle them"
  #      currentvalue = :silly
  #    end
  # 
  #    currentvalue
  #  end
  # 
  #  def group=(should)
  #    # Set our method appropriately, depending on links.
  #    if resource[:links] == :manage
  #      method = :lchown
  #    else
  #      method = :chown
  #    end
  # 
  #    begin
  #      File.send(method, nil, should, resource[:path])
  #    rescue => detail
  #      raise Puppet::Error, "Failed to set group to '#{should}': #{detail}"
  #    end
  #  end
end