# vim: set ft=ruby
#
# NOTE: requires both `vagrant-berkshelf` and `vagrant-omnibus` plugins

$golang_version = '1.1.1'
$ubuntu_provision_script = <<-EOSHELL
set -e
export DEBIAN_FRONTEND=noninteractive
cd /tmp
if [ ! -f godeb-amd64.tar.gz ] ; then
  curl -s -O https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz
fi
if [ ! -f godeb ] ; then
  tar xzf godeb-amd64.tar.gz
fi
if [ -z "$(go version 2>/dev/null | grep "go#{$golang_version}")" ] ; then
  ./godeb install #{$golang_version}
fi
apt-get update -y -qq
apt-get install -y -qq git-core
EOSHELL

Vagrant.configure("2") do |config|
  config.vm.hostname = "amqp-tools-berkshelf"
  config.vm.box = "canonical-ubuntu-12.04"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.network :private_network, ip: "33.33.33.10", auto_correct: true

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  config.berkshelf.enabled = true

  config.omnibus.chef_version = :latest

  config.vm.provision :shell, inline: $ubuntu_provision_script
  config.vm.provision :chef_solo do |chef|
    chef.log_level = ENV['DEBUG'] ? :debug : :info
    chef.json = {}
    chef.run_list = [
      "recipe[amqp-tools]",
      "minitest-handler"
    ]
  end
end
