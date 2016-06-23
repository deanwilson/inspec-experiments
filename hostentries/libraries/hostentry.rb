class HostEntries < Inspec.resource(1)
  name 'host_entries'

  desc "
    An inspec resource that represents the host entries defined
    in `/etc/hosts`
  "

  example "
    describe host_entries do
      it { should exist }

      its('count') { should == 17 }

      its('ipaddresses') { should include('127.0.0.1') }
      its('hostnames')   { should include('localhost') }
    end
  "

  def initialize
    @path = '/etc/hosts'

    @file = inspec.file(@path)
    return skip_resource "Can't find file '#{@path}'" if !@file.file?

    @entries = read_hosts(@path)
  end

  # Example method called by 'it { should exist }'
  # Returns true or false from the 'File.exists?' method
  def exists?
    return File.exists?(@path)
  end

  def count
    @entries.length
  end

  def read_hosts(file)
    entries = []

    File.readlines(file).each do |line|
      comment = nil

      line.chomp!

      next if line.match(/^\s*$/) # skip blank lines

      if line.sub!(/#(.*)$/, '')
        comment = $1
      end

      fields = line.split
      # all entries should have at least ip and hostname
      next unless fields.length >= 2

      ip       = fields.shift
      hostname = fields.shift
      aliases  = fields

      entries << {
        line: line,
        comment: comment,
        ip: ip,
        hostname: hostname,
        aliases: aliases,
      }
    end

    entries
  end

  def ipaddresses
    @entries.collect { |x| x[:ip] }
  end

  def hostnames
    @entries.collect { |x| [ x[:hostname] ] + x[:aliases] }.flatten
  end
end
