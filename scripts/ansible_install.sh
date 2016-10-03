#!/bin/sh

# Install supporting packages
yum -y install python-pip \
		PyYAML \
		python-jinja2 \
		python-httplib2 \
		python-keyczar \
		python-paramiko \
		git \
		openssl-devel \
		python-devel \
		wget \
		curl \
		nano

# Download the get-pip.py script
wget -o ~/get-pip.py https://bootstrap.pypa.io/get-pip.py

# Install pip using the get-pip.py
python /home/vagrant/get-pip.py

# Install Ansible and supporting packages
pip install paramiko PyYAML Jinja2 httplib2 six ansible==2.1.1.0

rm /home/vagrant/get-pip.py
