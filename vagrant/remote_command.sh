#!/bin/bash

for vmdir in .vagrant/machines/*; do
    vmname=`basename $vmdir`
    echo "$vmname \$: $1"
    ssh -l vagrant $vmname -- "$1"
    echo
done
