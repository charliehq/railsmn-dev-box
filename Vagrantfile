# Vagrant version 2
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box       = 'trusty64'
    config.vm.hostname = 'ruby-dev-box'

    #network
    config.vm.network :private_network, ip: "192.168.33.11"

    config.vm.provision :puppet,
        #:options        => '--verbose --debug',
        :manifests_path => 'puppet/manifests',
        :module_path    => 'puppet/modules'
        

    config.vm.provision :shell, :path => 'vagrant_init.sh'

    config.vm.synced_folder "./projects", "/projects"
end
