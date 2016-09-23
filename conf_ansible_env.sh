#!/bin/bash

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -e|--environment)
    ANSIBLE_ENVIRONMENT="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

arr=(`ls -l ansible/vars/ | grep '^d' | awk {'print $9'}`)
environment_match=false

if [ ! -z "$ANSIBLE_CONFIG" ]; then
  IFS='/' read -r -a path_array <<< "$ANSIBLE_CONFIG"
  CURRENT_ANSIBLE_ENVIRONMENT="${path_array[${#path_array[@]}-2]}"
  echo "Ansible Environment is current set to: $CURRENT_ANSIBLE_ENVIRONMENT"
else
  echo "Ansible Environment is not set"
fi

for i in "${arr[@]}"
do
  if [ "$ANSIBLE_ENVIRONMENT" == "$i" ]; then
    echo "Setting Environment to $ANSIBLE_ENVIRONMENT"
    export ANSIBLE_CONFIG="${PWD}/ansible/vars/${ANSIBLE_ENVIRONMENT}/ansible.cfg"
    export ANSIBLE_ENV="${ANSIBLE_ENVIRONMENT}"
    environment_match=true
  fi
done

if ! $environment_match ; then
  echo "Invalid environment provided, current valid environments include"

  for i in "${arr[@]}"
  do
    echo " - $i"
  done
fi
