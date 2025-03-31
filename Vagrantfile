Vagrant.configure("2") do |config|
  # Target VM: host1
  config.vm.define "host1" do |host1|
    host1.vm.box = "ubuntu/focal64"
    host1.vm.hostname = "host1"
    host1.vm.network "private_network", ip: "192.168.56.10"
    host1.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-server
      sudo systemctl enable ssh
      sudo systemctl start ssh
    SHELL
  end

  # Target VM: host2
  config.vm.define "host2" do |host2|
    host2.vm.box = "ubuntu/focal64"
    host2.vm.hostname = "host2"
    host2.vm.network "private_network", ip: "192.168.56.11"
    host2.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-server
      sudo systemctl enable ssh
      sudo systemctl start ssh
    SHELL
  end

  # Control VM: where you run the mass deployment script
  config.vm.define "control" do |control|
    control.vm.box = "ubuntu/focal64"
    control.vm.hostname = "control"
    control.vm.network "private_network", ip: "192.168.56.20"
    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-client git
    SHELL
    # Mount the project folder for easy access
    control.vm.synced_folder ".", "/home/vagrant/tenable-user-deploy"
  end
end
