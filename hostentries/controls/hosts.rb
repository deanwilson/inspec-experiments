control 'hostentries-sample' do

  title 'Host entries'
  desc 'Ensure a well known ip and hostname are present in /etc/hosts'

  describe host_entries do
    it { should exist }

    its('count') { should == 17 }

    its('ipaddresses') { should include('127.0.0.1') }
    its('hostnames')   { should include('puppetmigrator.example.org') }
  end
end
