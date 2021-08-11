#!/bin/bash
# ------------------------------------------------------------------
# Script Name: after_installation.sh
# Description: Cleaning up after the deployment was a success
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

output "Removing all dangling images"
docker system prune -f

