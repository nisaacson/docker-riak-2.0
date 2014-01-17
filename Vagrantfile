# -*- mode: ruby -*-
# vi: set ft=ruby :

BUILD_IMAGE = true          # build docker image from Dockerfile
PROVISION_DOCKER = true     # install docker daemon on virtual machine
STOP_ALL_CONTAINERS = true  # kill all running containers before launching a new one

# IP addresses. Virtual machines are configured with private networking
ALPHA_IP = '192.168.50.10'
BETA_IP = '192.168.50.20'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  if PROVISION_DOCKER
    config.vm.provision "docker" do |d|
      d.pull_images "ubuntu"
    end
  end




  ###################
  # Initial Shell Provisioner
  ###################
  config.vm.provision "shell", path: "./vagrant_scripts/initial.sh"

  if BUILD_IMAGE
    config.vm.provision "shell", path: "./vagrant_scripts/build_image.sh"
  end

  if STOP_ALL_CONTAINERS
    config.vm.provision "shell", path: "./vagrant_scripts/stop_all_containers.sh"
  end

  ###################
  # Virtual Machines
  ###################

  config.vm.define "alpha" do |alpha|
    alpha.vm.network :private_network, ip: ALPHA_IP
    alpha.vm.hostname = "alpha"
    alpha.vm.provision "shell" do |script|
      script.inline = "cd /vagrant/vagrant_scripts && ./solo.js --host-ip #{ALPHA_IP}"
    end
  end

  config.vm.define "beta" do |beta|
    beta.vm.network :private_network, ip: BETA_IP
    beta.vm.hostname = "beta"
    beta.vm.provision "shell" do |script|
      script.inline = "cd /vagrant/vagrant_scripts && ./join.js --host-ip #{BETA_IP} --join-ip #{ALPHA_IP}"
      script.args = BETA_IP, ALPHA_IP
    end
  end


  ###################
  # Virtualbox Provider
  ###################
  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "precise64_virtualbox"
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "5012"]
    vb.customize ["modifyvm", :id, "--cpus", "3"]
  end


  ###################
  # Vmware Fusion Provider
  ###################
  config.vm.provider :vmware_fusion do |v, override|
    # override box and box_url when using the "--provider vmware_fusion" flag
    override.vm.box = "precise64_fusion"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.gui = false
    v.vmx["memsize"] = "5012"
    v.vmx["numvcpus"] = "3"
  end
end
