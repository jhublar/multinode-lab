#!/bin/bash

if [ ! -z $ANSIBLE_ENV ]; then
  echo "Running Playbook: ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV"
  ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV
else 
  echo "ANSIBLE_ENV environmental variable not set"
fi 
