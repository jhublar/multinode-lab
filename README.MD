# Splunk Multinode Lab Environment #

This will install a multinode vagrant environment for the purpose of:
- Self training
- Testing of configurations in a local environment
- Development of splunk application for multi-node splunk environment

## Requirements: ##

### Ansible ###
- All Playbooks have been written for ansible version 2.1.1.0
- Note ansible version 2.1.2.0, released on the 30th of September changes the relative path from where the playbook was run from to the relative path of where the playbook sits.
- Note ansible version 2.1.2.0, exhibitied behaviours with connectivity issues

```TASK [setup] *******************************************************************
fatal: [idx01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh.", "unreachable": true}
fatal: [idx02]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh.", "unreachable": true}

PLAY RECAP *********************************************************************
clm01                      : ok=29   changed=0    unreachable=0    failed=0
idx01                      : ok=0    changed=0    unreachable=1    failed=0
idx02                      : ok=0    changed=0    unreachable=1    failed=0
localhost                  : ok=8    changed=0    unreachable=0    failed=0```

```$ ansible -m ping all
shd02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
shd01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
idx02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
idx01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
clm01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ufw01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}```

### Internet Connectivity: ###
- Yes! The faster the connectivity the better. The "mgmt" vagrant node installs ansible from the internet, if internet connectivity is an issue I suggest baking the install of ansible into the vagrant box and specifying a custom box in the guests.yml file for your environment

### Recommended Resources: ###
A powerful desktop or laptop, my specs are below and is giving good CPU / RAM / IO

- 8 GB 1600 MHz DDR3
- 2.6 GHz Intel Core i5
- SSD Disks

### Required plugins include: ###
- ansible provisioner   (For the execution of Ansible playbooks on the virtual machine)
- shell provisioner     (For the execution of Shell scripts on the virtual machine)
- landrush plugin       (DNS plugin to remove the annoyance of dealing with DNS strings)

#### __Note: Landrush will ask you to input you sudo credentials to create the /etc/resolver/{{ domain }}.conf__ ####

### Binaries ###

- The Splunk binaries will need to be downloaded to the repo directory see repo/readme for details (at the time of writing this splunk is at version 6.5.0)

## Known Issues ##
1. If the vagrant-vbguest plugin is installed this can add additional time to invoke an instance (times vary largely based on internet connection size and compute power). As a workaround create a packer box with the necessary customisations including virtualbox guest additions installed

2. The following error can occur in the event of a DNS failure with landrush (on Mac OS X)

    ```RUNNING HANDLER [splunk : splunk restart] **************************************
fatal: [idx01]: FAILED! => {"changed": false, "failed": true, "msg": "Job for splunk.service failed because a timeout was exceeded. See \"systemctl status splunk.service\" and \"journalctl -xe\" for details.\n"}```

    Confirm the issue is with DNS cache by pinging the dns names.

    - clm01.dev.avocado.lab
    - shd01.dev.avocado.lab
    - idx01.dev.avocado.lab
    - idx02.dev.avocado.lab

    If DNS resolution to these URLs above fail, run the ./clear_dns_cache.sh to clear the DNS cache 

## To run ##

1. Checkout the Git Repo

2. Download the Splunk binaries to the repo/ folder, seen repo/readme for wget urls - replaced with ansible tasks

3. Ensure the vagrant private key under that ansible folder (ansible/vars/dev/keys/insecure_private_key) has the correct permission (chmod 0600) - replaced with ansible tasks

4. Running "vagrant up" will check to see if the Ansible environment variables have been set prior to execution. If ansible environmental variable are not set, use "source conf_ansible_env.sh -e {{ dev }} -p {{ vagrant_provider }}" to set the provider and environment, default vagrant provider is virtualbox.

    - Running "./conf_ansible_env.sh -e list" to see a list of environments

    - Running "./conf_ansible_env.sh -p list" to see a list of providers

5. Once the environment variables have been set use vagrant up to power on the virtual machines, and configure the splunk instances.

6. ssh to the mgmt box "vagrant ssh mgmt" and "cd /vagrant", set the environment variable (using step 4 documented above).

7. Execute the ansible run command: ./run_main_play.sh, not the last task on each host should give the URL of the Splunk web interface.

8. Default Password for all Splunk instances are admin/changeme
