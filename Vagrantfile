# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network :private_network, ip: "10.0.1.3"
  config.vm.hostname = "symfony.localhost"

  config.hostsupdater.remove_on_suspend = true
  config.hostsupdater.aliases = ["symfony.localhost"]

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--vram", "8"]
  end

  config.vm.provision "shell", path: "etc/vagrant/bootstrap.sh"
end
