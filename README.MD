# Splunk Multinode Lab Environment #

This will install a multinode vagrant environment for the purpose of:

- Self training
- Testing of configurations in a local environment
- Development of splunk application for multi-node and single instance Splunk environment

## Requirements: ##

### Ansible ###
- All Playbooks have been written for ansible version 2.1.1.0
- Note Ansbile is not needed on the host machine it will be installed on the mgmt guest machine
- Note ansible version 2.1.2.0, released on the 30th of September changes the use of relative paths from where the playbook was run from to the relative path of where the playbook sits.
- Note ansible version 2.1.2.0, exhibitied behaviours with connectivity issues see output below, ansible pings are successful but playbooks will not connect

```
TASK [setup] *******************************************************************
fatal: [idx01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh.", "unreachable": true}
fatal: [idx02]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh.", "unreachable": true}

PLAY RECAP *********************************************************************
clm01                      : ok=29   changed=0    unreachable=0    failed=0
idx01                      : ok=0    changed=0    unreachable=1    failed=0
idx02                      : ok=0    changed=0    unreachable=1    failed=0
localhost                  : ok=8    changed=0    unreachable=0    failed=0
```

```
$ ansible -m ping all
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
}
```

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

#### __Note: Landrush will ask you to input you sudo credentials to create the /etc/resolver/{{ domain }}.conf on the initial run__ ####

### Binaries ###

- The Splunk binaries will need to be downloaded to the repo directory see repo/readme for details (at the time of writing this splunk is at version 6.5.0)
- If Splunk binaries are not present the local ansible roles will download the binaries from www.splunk.com

## Known Issues ##
1. If the vagrant-vbguest plugin is installed this can add additional time to invoke an instance (times vary largely based on internet connection size and computation power). As a workaround create a packer box with the necessary customisations including virtualbox guest additions.

2. The following error can occur in the event of a DNS failure with landrush (on Mac OS X)

    ```
    RUNNING HANDLER [splunk : splunk restart] **************************************
    fatal: [idx01]: FAILED! => {"changed": false, "failed": true, "msg": "Job for splunk.service failed because a timeout was exceeded. See \"systemctl status splunk.service\" and \"journalctl -xe\" for details.\n"}
    ```

    Confirm the issue is with DNS cache by pinging the dns names.

##### __Environment: Cluster__ #####

    - clm01.cluster.avocado.lab
    - shd01.cluster.avocado.lab
    - shd02.cluster.avocado.lab
    - idx01.cluster.avocado.lab
    - idx02.cluster.avocado.lab
    - ufw01.cluster.avocado.lab
    - mgmt.cluster.avocado.lab

##### __Environment: Single__ #####

    - spl01.single.avocado.lab
    - mgmt.single.avocado.lab

    If DNS resolution to these URLs above fail, run the ./clear_dns_cache.sh to clear the DNS cache

## To run ##

Two types of Splunk Environments have been configured "cluster" and "single", cluster will be selected by default.  The virtual box nodes that will be power on for each environment are as follows:

##### __Environment: Cluster__ #####

    - clm01.cluster.avocado.lab
    - shd01.cluster.avocado.lab
    - shd02.cluster.avocado.lab
    - idx01.cluster.avocado.lab
    - idx02.cluster.avocado.lab
    - ufw01.cluster.avocado.lab
    - mgmt.cluster.avocado.lab

##### __Environment: Single__ #####

    - spl01.single.avocado.lab
    - mgmt.single.avocado.lab

### Instructions ###

1. Checkout the Git Repo

2. __replaced with ansible tasks__ - Download the Splunk binaries to the repo/ folder, seen repo/readme for wget urls

3. __replaced with ansible tasks__ - Ensure the vagrant private key under that ansible folder (ansible/vars/{{ environment }}/keys/insecure_private_key) has the correct permission (chmod 0600)

Note. Running "vagrant up" will check to see if the ansible environment variables have been set prior to execution. If ansible environmental variable are not set, use "source conf_ansible_env.sh -e {{ environment }} -p {{ vagrant_provider }}" to set the provider and environment, default vagrant provider is virtualbox, and default environment is cluster

    - Running "./conf_ansible_env.sh -e list" to see a list of environments

    - Running "./conf_ansible_env.sh -p list" to see a list of providers

4. Once the environment variables have been set use vagrant up to power on the virtual machines, and configure.

5. ssh to the mgmt box "vagrant ssh mgmt" and "cd /vagrant", set the environment variable in the mgmt box (use step 3 documented above).

6. Execute the ansible run command: ./run_main_play.sh, note the last task on each host should give the URL of the Splunk web interface.

7. Default Password for all Splunk instances are admin/changeme
