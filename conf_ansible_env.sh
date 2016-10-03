#!/bin/bash
function show_env_vars()
{
  echo "Set variables with the following flags"
  echo " -e {{ ENVIRONMENT }}"
  echo " -p {{ VAGRANT_PROVIDER }}"
  echo "Example Usage: source conf_ansible_env.sh -e dev -p parallels"
  echo ""
  echo "Current settings are:"
  echo "ANSIBLE_ENV: $ANSIBLE_ENV"
  echo "ANSIBLE_CONFIG: $ANSIBLE_CONFIG"
  echo "VAGRANT_DEFAULT_PROVIDER: $VAGRANT_DEFAULT_PROVIDER"
}

function set_environment()
{
  ANSIBLE_ENVIRONMENT=$1
  environments=(`ls -l ansible/vars/ | grep '^d' | awk {'print $9'}`)
  environments_match=false
  list_environments=false

  if [ ! -z "$ANSIBLE_ENVIRONMENT" ]; then
    if [ ! -z "$ANSIBLE_CONFIG" ]; then
      IFS='/' read -r -a path_array <<< "$ANSIBLE_CONFIG"
      CURRENT_ANSIBLE_ENVIRONMENT="${path_array[${#path_array[@]}-2]}"
      echo "Ansible Environment is current set to: $CURRENT_ANSIBLE_ENVIRONMENT"
    else
      echo "Ansible Environment is not set"
    fi

    for i in "${environments[@]}"
    do
      length=$((${#i}-1))

      if [ "/" == "${i:$length:1}" ];then
        i="${i:0:$length}"
      fi

      if [ "$ANSIBLE_ENVIRONMENT" == "$i" ]; then
        echo "Setting Environment to $ANSIBLE_ENVIRONMENT"
        export ANSIBLE_CONFIG="${PWD}/ansible/vars/${ANSIBLE_ENVIRONMENT}/ansible.cfg"
        export ANSIBLE_ENV="${ANSIBLE_ENVIRONMENT}"
        environments_match=true
      elif [ "$ANSIBLE_ENVIRONMENT"=="list" ]; then
        list_environments=true
      fi
    done

    if ! $environments_match; then
      if $list_environmments; then
        echo "Selectable vagrant environments are"
      else
        echo "Invalid environment, current vagrant environments include"
      fi

      for i in "${environments[@]}"
      do
        length=$((${#i}-1))

        if [ "/" == "${i:$length:1}" ];then
          i="${i:0:$length}"
        fi

        echo " - $i"
      done
    fi
  fi
}

function set_providers()
{
  VAGRANT_PROVIDER=$1
  providers=(virtualbox parallels)
  providers_match=false
  list_providers=false

  if [ ! -z "$VAGRANT_PROVIDER" ]; then
    if [ ! -z "$VAGRANT_DEFAULT_PROVIDER" ]; then
      echo "Current Default Vagrant provider is current set to: $VAGRANT_DEFAULT_PROVIDER"
    else
      echo "Current Default Vagrant provider is not set"
    fi

    for i in "${providers[@]}"
    do
      if [ "$VAGRANT_PROVIDER" == "$i" ]; then
        echo "Setting Default Provider to $VAGRANT_PROVIDER"
        export VAGRANT_DEFAULT_PROVIDER="$i"
        providers_match=true
      elif [ "$VAGRANT_PROVIDER"=="list" ]; then
        list_providers=true
      fi
    done

    if ! $providers_match ; then
      if $list_providers; then
        echo "Selectable vagrant providers are"
      else
        echo "Invalid provider, current valid providers include"
      fi

      for i in "${providers[@]}"
      do
        echo " - $i"
      done
    fi
  fi
}

option_env=false
option_pro=false

while [[ $# -gt 1 ]]; do
key="$1"
  case $key in
    -e)
      set_environment $2
      option_env=true
      shift
      shift
      ;;
    -p)
      set_providers $2
      option_pro=true
      shift
      shift
      ;;
  esac
done

# If no options are passed print out the current settings
if ! $option_pro && ! $option_env;
then
  show_env_vars
fi
