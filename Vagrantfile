# -*- mode: ruby -*-
# vi: set ft=ruby :

#require 'berkshelf/vagrant'

# Attempt to install required plugins
# Chef Omnibus
#if !Vagrant.has_plugin?('vagrant-omnibus') &&  ENV['SKIP'] != 'true'
#  if RUBY_PLATFORM =~ /win/ && RUBY_PLATFORM !~ /darwin/
#    puts "The vagrant-omnibus plugin is required. Please install it with \"vagrant plugin install vagrant-omnibus\""
#    exit
#  end
#
#  print "Installing vagrant plugin vagrant-omnibus..."
#  %x(bash -c "export SKIP=true; vagrant plugin install vagrant-omnibus") unless Vagrant.has_plugin?('vagrant-omnibus') || ENV['SKIP'] == 'true'
#  puts "Done!"
#  puts "Please re-run your vagrant command..."
#  exit
#end

# Vagrant triggers
if !Vagrant.has_plugin?('vagrant-triggers') &&  ENV['SKIP'] != 'true'
  if RUBY_PLATFORM =~ /win/ && RUBY_PLATFORM !~ /darwin/
    puts "The vagrant-triggers plugin is required. Please install it with \"vagrant plugin install vagrant-triggers\""
    exit
  end

  print "Installing vagrant plugin vagrant-triggers..."
  %x(bash -c "export SKIP=true; vagrant plugin install vagrant-triggers") unless Vagrant.has_plugin?('vagrant-triggers') || ENV['SKIP'] == 'true'
  puts "Done!"
  puts "Please re-run your vagrant command..."
  exit
end


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "application-berkshelf"

  # Set the version of chef to install using the vagrant-omnibus plugin
  #config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then 
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # is not a Vagrant Cloud box and if it doesn't already exist on the 
  # user's system.
  # config.vm.box_url = "https://vagrantcloud.com/chef/ubuntu-14.04/version/1/provider/virtualbox.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: "dhcp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  config.vm.network "forwarded_port", guest: 27017, host: 27017, auto_correct: true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
  end

  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  # config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  # Bootstrap Berkshelf cookbooks
  cookbooks_path = "kerkberks"

  [:up, :provision].each do |cmd|
    config.trigger.before cmd, :stdout => true do
      info 'Cleaning cookbook directory'
      run "rm -rf #{cookbooks_path}"
      info 'Installing cookbook dependencies with berkshelf'
      if File.exist?('Berksfile.lock')
        run "berks update"
      end
      run "berks vendor #{cookbooks_path}"
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    #chef.data_bags_path = "data_bags"
    chef.environments_path = "environments"
    chef.environment = "cookbook-test"
    chef.cookbooks_path = ["#{cookbooks_path}"]
    node = JSON.parse(File.read("node.json"))
    chef.json.merge!(node)
  end
end
