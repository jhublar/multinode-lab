This will install a multinode vagrant environment for the purpose of:
- Self training
- Testing of configurations in a local environment
- Development of splunk application for multi-node splunk environment

Reqiurements:

Internet Connectivity:
- Yes! The faster the connectivity the better. The "mgmt" vagrant node installs ansible from the internet, if internet connectivity is an issue I suggest baking the install of ansible into the vagrant box and specifying a custom box in the guests.yml file for your environment

Resources:
A powerful desktop or laptop my specs are as follows giving good CPU / RAM / IO,
- 8 GB 1600 MHz DDR3
- 2.6 GHz Intel Core i5
- SSD Disks

Required plugins include:
- ansible provisioner   (For the execution of Ansible playbooks on the virtual machine)
- shell provisioner     (For the execution of Shell scripts on the virtual machine)
- landrush plugin       (DNS plugin to remove the annoyance of dealing with DNS strings)

* Note: Landrush will ask you to input you sudo credentials to create the /etc/resolver/{{ domain }}.conf

Binaries:

- The Splunk binaries will need to be downloaded to the repo directory see repo/readme for details (at the time of writing this splunk is at version 6.4.3)

Known Issues:
- If the vagrant-vbguest plugin is installed this can take several minutes to install. As a workaround I have created my own packer box with the necessary customisations

To run:

1. Checkout the Git Repo

2. Download the Splunk binaries to the repo/ folder, seen repo/readme for wget urls

3. Ensure the vagrant private key under that ansible folder (ansible/vars/dev/keys/insecure_private_key) has the correct permission (chmod 0600)

4. Running "vagrant up" will check to see if the Ansible environment variables have been set. If ansible environment are not set, use "source conf_ansible_env.sh -e environment -p parallels" to set the provider and environment, default vagrant provider is virtualbox
   Running "./conf_ansible_env.sh -e list" to see a list of environments (only dev have been configured)
   Running "./conf_ansible_env.sh -p list" to see a list of providers (providers currently supported by this lab are virtualbox and parallels)

5. Once the environment variables have been set use vagrant up to power on the virtual machines, and configure the splunk instances.

6. ssh to the mgmt box "vagrant ssh mgmt" and "cd /vagrant", set the environment variable using step 4 documented above.

7. Execute the ansible run command: ./run_main_play.sh, not the last task on each host should give the URL of the Splunk web interface.

8. Default Password for all Splunk instances are admin/changeme
