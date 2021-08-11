#!/bin/bash
# ------------------------------------------------------------------
# Script Name: kubernetes_deploy.sh
# Description: Deploying kubernetes objects to EKS cluster
# Author     : QA
# ------------------------------------------------------------------

error()
{
    echo "[ERROR]:" "$1" "EXITING"1>&2
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

output "Deploying the backend object"
kubectl apply -f ./pods/backend.yml

output "Deploying the frontend object"
kubectl apply -f ./pods/frontend.yml

output "Delay NGINX start for 1 minute while waiting for frontend pods to start running"
sleep 1m

output "Deploying the nginx object"
kubectl apply -f ./pods/nginx.yml

# Improvement to be made
# ----------------------------------
# Write a function that looks at the 
# status of the load balancer

output "Waiting 2 minute for health check of load balancer to compelete"
sleep 2m
