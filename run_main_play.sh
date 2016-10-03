#!/bin/bash

if [ ! -z $ANSIBLE_ENV ]; then
  echo "Running Playbook: ansible-playbook playbook.yml --extra-vars vars_location=$ANSIBLE_ENV"
  ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV -v
else
  echo "ANSIBLE_ENV environmental variable not set"
  echo "use \"source conf_ansible_env.sh -e {{ environment }}\" to set"
fi
