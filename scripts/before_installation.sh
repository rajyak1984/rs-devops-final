#!/bin/bash
# ------------------------------------------------------------------
# Script Name: before_installation.sh
# Description: Checking if everything is working is ready to build
#              and deploy the petclinic application
# Author     : QA
# ------------------------------------------------------------------

error()
{
    echo "[ERROR]:" "$1" "EXITING" 1>&2
    exit 1
}

warning()
{
    echo "[WARNING]:" "$1" 1>&2
}

output()
{
    echo "[OUTPUT]:" "$1" 1>&2
}

output "Updating to make sure the latest security patches are installed"
sudo apt update -y

if [[ "$(aws --version 2> /dev/null)" == "" ]]; then
    error "AWS CLI is not installed"
fi

# Improvement to be made
# ----------------------------------
# Check to see if the manager node is already
# part of a cluster, due to constant deployment
# this could mean you are also connecting
# when it is already connected.

aws eks update-kubeconfig --name qa_cluster