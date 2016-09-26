default_ram = "256"
default_box = "centos/7"
default_env = "dev"
default_domain = "avocado.lab"
scripts_path = "scripts"
environment = ENV['ANSIBLE_ENV'] || default_env
environment_domain = "#{environment}.#{default_domain}"
plugins_required = ["shell", "ansible", "landrush", ]

require 'yaml'
require 'rbconfig'

# Check vagrant plugins are installed
plugins_required.each { |name|
  if Vagrant.has_plugin?(name)
    puts "Plugin #{name} installed"
  else
    puts "Plugin #{name} not installed, this Vagrantfile requires plugin #{name}, please run \"vagrant plugin install #{name}\""
    exit(1)
  end
}

guests = YAML.load(File.open(File.join(File.dirname(__FILE__), "ansible/vars/#{environment}/guests/guests.yml"), File::RDONLY).read)

Vagrant.configure("2") do |config|

  config.landrush.enabled = true
  config.landrush.tld = default_domain
  config.landrush.guest_redirect_dns = false

  config.ssh.insert_key = false

  guests.each do |name,options|
    config.vm.define name do |guest_config|
      hostname = [name, environment_domain].join('.')
      guest_config.vm.host_name = hostname
      guest_config.vm.box = options['box'] || default_box
      memory = options['ram'] || default_ram

      if(options['scripts'] != nil)
        options['scripts'].each do |script|
          guest_config.vm.provision :shell, :path => "#{scripts_path}/#{script}.sh"
        end
      end

      guest_config.vm.network "forwarded_port", guest: 22, host: options['ssh_port'], id: 'ssh'

      guest_config.vm.provider :virtualbox do |v|
        v.name   = hostname
        v.cpus   = 1
        v.memory = memory.to_s
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
   
      guest_config.vm.provider :parallels do |v|
        v.name = hostname
        v.cpus = 1
        v.memory = memory.to_s
      end

      # Only used if directly provisioning - Uncomment below and update ansible inventory file to reflect local ports
      # if( RbConfig::CONFIG["host_os"] =~ /linux/ && name != "mgmt" )
      #   guest_config.vm.provision "ansible" do |ansible|
      #     ansible.verbose = "v"
      #     ansible.playbook = "ansible/playbook.yml"
      #     ansible.inventory_path = "ansible/vars/#{environment}/inventory/hosts"
      #     ansible.extra_vars = { vars_location: "#{environment}" }
      #   end
      # end
    end
  end
end
