#!/bin/sh

sudo echo "
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
       	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# Setup base_profile prompt
export PS1='\[\033[1;30m\][\[\033[0;32m\]\u\[\033[1;30m\]@\[\033[1;34m\]\h\[\033[1;30m\]|\[\033[0;31m\]\t\[\033[1;30m\]|\[\033[0;35m\] \w\[\033[1;30m\]] \[\033[0m\]\$ '

" > /root/.bash_profile

echo "
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
       	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# Setup base_profile prompt
export PS1='\[\033[1;30m\][\[\033[0;32m\]\u\[\033[1;30m\]@\[\033[1;34m\]\h\[\033[1;30m\]|\[\033[0;31m\]\t\[\033[1;30m\]|\[\033[0;35m\] \w\[\033[1;30m\]] \[\033[0m\]\$ '

" > /home/vagrant/.bash_profile

sudo chown vagrant:vagrant /home/vagrant/.bash_profile
