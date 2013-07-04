#
# Cookbook Name:: dovecot
# Recipe:: default
#
# Copyright 2012, Oversun-Scalaxy LTD
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Installing required packages according to platform
case node['platform']
  when 'debian','ubuntu'
    package 'dovecot-imapd' 
  when 'sles'
    package 'dovecot'
end

# Creaate user vmail to use virtual users feature.
user 'vmail' do
  action :create
end

service "dovecot" do
  action :nothing
end

file node['dovecot']['passwd-file'] do
  owner 'root'
  group 'root'
  mode  '644'
  action  :create_if_missing
  notifies :restart, resources(:service => 'dovecot')
end

# Using our configuration template as dovecot.cfg
template "#{node['dovecot']['conf_dir']}/dovecot.conf" do
  source  "dovecot-conf.erb"
  owner   "root"
  group   "root"
  mode    "644"
  notifies :reload, resources(:service => 'dovecot')
end

execute "setfacl -Rm d:u:vmail:rwx,u:vmail:rwx,d:g:vmail:rwx,g:vmail:rwx #{node['dovecot']['mail_location']['directory']}"
execute "usermod -a -G vmail Debian-exim"

cookbook_file "/usr/sbin/dovecotuseradd" do
  source  "dovecotuseradd"
  owner   "root"
  mode    "750"
end

cookbook_file "/usr/sbin/dovecotuserdel" do
  source  "dovecotuserdel"
  owner   "root"
  mode    "750"
end
