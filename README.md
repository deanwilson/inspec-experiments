# inspec experiments

This repo contains my little experiments with [inspec](https://www.chef.io/inspec/)
from Chef. _"An open-source testing framework
for infrastructure with a human- and machine-readable language for
specifying compliance, security and policy requirements."_

The code snippets here are all small, self-contained experiments
rather than fully developed reusable examples. While they should work
it'd be very optimistic to think you could drop them directly in to
your code base without any tinkering. If any of them end up being
refined and reusable I'll probably extract them in to separate, more
supported, git repos.

## hostentries custom type

This is a simple custom type, deployable as a profile, that lets you run some basic
tests over the `/etc/hosts` file as a whole. I wrote it while trying to learn how difficult
it'd be to extend `inspec` with new resources.


    # example tests
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


And example output looks like -

    inspec exec hostentry

    Profile: Hostentry InSpec Profile (hostentries)
    Version: 0.1.0

      ✔  hostentries-sample: Host entries

    Summary:   4 successful    0 failures    0 skipped


#### License

All the code in this repo is licensed under the `GPLv2` unless stated
otherwise in the per directory `README.md` files.

#### Author

  [Dean Wilson](http://www.unixdaemon.net)
