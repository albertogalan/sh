IMAGE_NAME = "ubuntu/focal64"
N = 1

$script = <<-SCRIPT

curl https://raw.githubusercontent.com/albertogalan/sh/develop/sh/scripts/i3-desktop.sh | bash -s debian 
SCRIPT

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provision "shell", inline: $script
    config.ssh.username = "vagrant"

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 3
    end
      
    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.56.#{i + 10}"
            node.vm.hostname = "node-#{i}"
        end
    end
end
