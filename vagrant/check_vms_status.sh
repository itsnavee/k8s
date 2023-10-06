#!/bin/bash
for vmdir in .vagrant/machines/*; do
    vmname=`basename $vmdir`
    [ -f $vmdir/virtualbox/id ] && id=`cat $vmdir/virtualbox/id` || continue
    echo $vmname `vboxmanage showvminfo --machinereadable $id | grep ^VMState= | cut -f2 -d '"'`
done
