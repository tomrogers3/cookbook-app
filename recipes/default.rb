#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "docker"
include_recipe "golang"
include_recipe "golang::packages"
include_recipe "nodejs"


Chef::Log.info("Setting up environment: " + node.chef_environment)

if node.chef_environment != "dev"
  # Set up application user
  group node[:application][:group]
  
  user node[:application][:user][:name] do
    password node[:application][:user][:password]
    group node[:application][:group]
    supports :manage_home => true
    system node[:application][:user][:system]
    home node[:application][:user][:home]
    shell "/bin/bash"
  end
else
  Chef::Log.info("Skipping application user creation...")
end


# Install and run external services as docker containers

Chef::Log.info("Install and run docker containers...")

# Pull Mongo image
docker_image "mongo"

# Mongo
docker_container "mongo" do
  container_name "db"
  detach true
  port node[:application][:db][:port] + ":" + node[:application][:db][:port]
  #volume "/mnt/docker/db:/docker-storage/db"
  action :run
end

# Pull gnatsd image - for high performance messaging
docker_image "apcera/gnatsd"

docker_container "apcera/gnatsd" do
  container_name "mq"
  detach true
  # by default, ports 4222 and 8333 are exposed for client and monitor ports respectively
  port ["4222:4222", "8333:8333"]
  action :run
end

Chef::Log.info("Install and run docker containers...done.")


# Install global npm packages
nodejs_npm "grunt-cli"
nodejs_npm "bower"


# if node.chef_environment != "cookbook-test"

#   # Install local npm packages
#   execute "npm-install" do
#     cwd node[:application][:install_location]
#     command "npm install"
#     user node[:application][:user][:name]
#     group node[:application][:group]
#     action :run
#   end

# end
