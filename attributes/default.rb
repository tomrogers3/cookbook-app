## User ##
default[:application][:group] = "vagrant"
default[:application][:user][:name] = "vagrant"
default[:application][:user][:home] = "/home/vagrant"
default[:application][:user][:system] = false

## Database ##
default[:application][:db][:port] = "27017"

## Application ##
default[:application][:install_location] = "/vagrant"