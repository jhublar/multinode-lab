#!/bin/bash

# If Vagrant is not reponding to failed dns requests on Mac OS X, clear the DNS cache with the following commnad
sudo killall -HUP mDNSResponder
