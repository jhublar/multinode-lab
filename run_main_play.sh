#!/bin/bash

if [ ! -z $ANSIBLE_ENV ]; then
  ansible-playbook ansible/playbook.yml --extra-vars vars_location=$ANSIBLE_ENV
else 
  echo "ANSIBLE_ENV environmental variable not set"
fi 
