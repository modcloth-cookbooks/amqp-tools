#
# Cookbook Name:: amqp-tools
# Recipe:: install
#
# Copyright 2013, ModCloth, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

gopath = "#{node['install_prefix']}/go/shared/gopath"

directory "#{gopath}/bin" do
  mode 0755
  recursive true
end

git "#{Chef::Config[:file_cache_path]}/amqp-tools" do
  repository node['amqp_tools']['git_repo']
  reference node['amqp_tools']['git_ref']
  action :sync
  notifies :run, 'bash[install-amqp-tools]'
end

bash 'install-amqp-tools' do
  cwd "#{Chef::Config[:file_cache_path]}/amqp-tools"
  code 'make'
  environment(
    'PATH' => %w{
      /opt/local/bin
      /opt/local/sbin
      /usr/bin
      /usr/local/go/bin
      /usr/sbin
      /bin
      /sbin
    }.join(':'),
    'GOPATH' => "#{gopath}:",
    'GOBIN' => ''
  )
  action :nothing
  notifies :create, "link[#{node['install_prefix']}/bin/amqp-consume-cat]"
  notifies :create, "link[#{node['install_prefix']}/bin/amqp-publish-files]"
end

%w(
  amqp-consume-cat
  amqp-publish-files
).each do |exe|
  link "#{node['install_prefix']}/bin/#{exe}" do
    to "#{gopath}/bin/#{exe}"
    action :nothing
  end
end
