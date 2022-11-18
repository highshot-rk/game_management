# vagrant plugin install vagrant-vbguest
# vagrant plugin install vagrant-docker-compose
Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '4096']
  end

  config.vm.network :forwarded_port, guest: 80, host: 8082
  config.vm.provision :docker
  config.vm.provision :docker_compose,
                      yml: '/vagrant/docker-compose-development.yml', run: 'always'
end
