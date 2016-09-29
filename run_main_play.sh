#!/bin/bash

if [ ! -z $ANSIBLE_ENV ]; then
  echo "Running Playbook: ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV"
  ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV
else
  echo "ANSIBLE_ENV environmental variable not set"
  echo "use \"source conf_ansible_env.sh -e {{ environment }}\" to set"
fi
