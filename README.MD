

This will install a multinode vagrant environment for the purpose of:
- Self training
- Testing of configuration in a local environment
- Development of splunk application for multi-node splunk environment

Reqiurements:

Internet Connectivity:
- Yes! The faster the connectivity the better. The "mgmt" vagrant node installs ansible from the internet, if internet connectivity is an issue I suggest baking the install of ansible into the vagrant box.

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

2. Download the Splunk binaries to the repo/ folder

3. Ensure the vagrant private key under that ansible folder (ansible/vars/dev/keys/insecure_private_key) has the correct permission (chmod 0600)

4. Running "vagrant up" will check to see if the Ansible environment variables have been set. If ansible environment are not set, use "source conf_ansible_env.sh -e environmnet" to set
   Running "./config_ansible_env.sh" to see a list of environment

5. Once the environment variables have been set use vagrant up to power on the virtual machine, and configure the splunk instances

6. Default Password for all Splunk instances are admin/changeme
