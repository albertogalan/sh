IMAGE_NAME = "ubuntu/focal64"
N = 1

$script = <<-SCRIPT

curl https://raw.githubusercontent.com/albertogalan/sh/develop/sh/scripts/i3-desktop.sh | bash -s debian 
SCRIPT

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.ssh.username = "vagrant"
    config.vm.provision "file", source: "~/.ssh/known_hosts", destination: ".ssh/known_hosts"
    config.vm.provision "file", source: "~/.ssh/id_rsa", destination: ".ssh/agalan-github-key"
    config.vm.provision "shell", inline: $script

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 3
				if RUBY_PLATFORM =~ /darwin/
      		vb.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda'] # choices: hda sb16 ac97
    		elsif RUBY_PLATFORM =~ /mingw|mswin|bccwin|cygwin|emx/
      		vb.customize ["modifyvm", :id, '--audio', 'dsound', '--audiocontroller', 'ac97']
    		end
    end
     
    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.56.#{i + 10}"
            node.vm.hostname = "node-#{i}"
        end
    end
end
