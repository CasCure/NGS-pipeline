#!/bin/bash

# Ref: https://docs.docker.com/engine/install/ubuntu/

sudo apt-get update
sudo apt-get install apt-transport-https \
      ca-certificates curl gnupg-agent \
      software-properties-common \
      awscli

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo docker pull broadinstitute/gatk
