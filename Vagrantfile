begin
  require 'berkshelf/vagrant'
rescue LoadError
  puts "[WARNING] Berkshelf not found in your Vagrant's RubyGems but your Vagrantfile is attempting"
  puts "[WARNING] to require the Berkshelf Vagrant plugin! Install the Berkshelf Vagrant plugin or"
  puts "[WARNING] remove the 'require \"berkshelf/vagrant\"' line from the top of your Vagrantfile."
  puts ""
  puts "If you installed Vagrant by RubyGems:"
  puts "  Install Berkshelf by running: \"gem install berkshelf\""
  puts "If you installed Vagrant by one of the pre-packaged installers:"
  puts "  Install Berkshelf by running: \"vagrant gem install berkshelf\""
  puts ""
end

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.guest = :windows
  config.vm.box = "windows-2008r2-standard"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "#{ENV['HOME']}/devel/vagrant/00boxes/windows-2008r2-standard.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  config.vm.boot_mode = :gui

  config.vm.forward_port 3389, 3390, :name => "rdp", :auto => true
  config.vm.forward_port 5985, 5985, :name => "winrm", :auto => true
  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  config.vm.customize ["modifyvm", :id, "--vram", 48]
  config.vm.customize ["modifyvm", :id, "--cpus", 2]

  config.vm.host_name = "couchbase-berkshelf"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :hostonly, "33.33.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.

  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }

    chef.run_list = [
      "recipe[couchbase::server]"
    ]
  end
end
