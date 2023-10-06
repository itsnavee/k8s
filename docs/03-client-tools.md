# Installing the Client Tools

First identify a system from where you will perform administrative tasks, such as creating certificates, kubeconfig files and distributing them to the different VMs.

If your host where you are running vagrant and virtualbox is linux, then tyou can use your host to access the VMs to perform administrative tasks.

But if not, then you can also chose one of the VMs, lets say `master-1` node, to perform administrative tasks. 

Whichever system you chose make sure that system is able to access all the provisioned VMs through SSH to copy files over.

## Enable access to all VMs

### Option-a: Use host linux machine (preferred)

Vagarnt creates ssh config for all hosts that you can see by executing the following command:

```
cd vagrant
vagrant ssh-config
```

Add vagrant ssh config to your local host machines's ssh config:

```
vagrant ssh-config >> ~/.ssh/vagrant.conf
echo "Include ~/.ssh/vagrant.conf" >> ~/.ssh/config
```

Now you should be able to login to the machines with `vagrant ssh` command, lets try:

```
ssh master-1
```

Optionally you can try to login to other hosts to verify, I have also put a `remote_command.sh` script that you can use to verify your login:

```
./remote_command.sh "hostname"
```

Lastly, lets add nodes hosts information from `/etc/hosts` file from one of the nodes to the host machine:

```
ssh master-1 -- "cat /etc/hosts"
```

This will show the host information of all nodes similar to this:

```
192.168.56.11	master-1
192.168.56.12	master-2
192.168.56.21	worker-1
192.168.56.22	worker-2
192.168.56.30	loadbalancer
```

Add this to the host machine now:

```
~/k8s/vagrant (main*) » sudo vim /etc/hosts
<add above 5 lines to the end of the file>
```

Check if hosts file info is usable:

```
~/k8s/vagrant (main*) » dig master-1 +short
192.168.56.11
```


### Option-b: Using one of the nodes `master-1`

Here we create an SSH key pair for the `vagrant` user who we are logged in as. We will copy the public key of this pair to the other master and both workers to permit us to use password-less SSH (and SCP) go get from `master-1` to these other nodes in the context of the `vagrant` user which exists on all nodes.

Generate Key Pair on `master-1` node

```bash
ssh-keygen
```

Leave all settings to default.

View the generated public key ID at:

```bash
cat ~/.ssh/id_rsa.pub
```

Add this key to the local authorized_keys (`master-1`) as in some commands we scp to ourself

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Copy the output into a notepad and form it into the following command

```bash
cat >> ~/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...OUTPUT-FROM-ABOVE-COMMAND...8+08b vagrant@master-1
EOF
```

Now ssh to each of the other nodes and paste the above from your notepad at each command prompt.

## Install kubectl

The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl). command line utility is used to interact with the Kubernetes API Server. Download and install `kubectl` from the official release binaries:

Reference: [https://kubernetes.io/docs/tasks/tools/install-kubectl/](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Linux

Use `remote_command.sh` to download and install `kubectl` on all nodes:

```
./remote_command "wget https://storage.googleapis.com/kubernetes-release/release/v1.24.3/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/"

```

### Verification

Verify `kubectl` version 1.24.3 or higher is installed:

```
./remote_command.sh "kubectl version --short"
```

> output

```
~/k8s/vagrant (main*) » ./remote_command.sh "kubectl version --short"

loadbalancer $: kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.3
Kustomize Version: v4.5.4
The connection to the server localhost:8080 was refused - did you specify the right host or port?

master-1 $: kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.3
Kustomize Version: v4.5.4
The connection to the server localhost:8080 was refused - did you specify the right host or port?

master-2 $: kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.3
Kustomize Version: v4.5.4
The connection to the server localhost:8080 was refused - did you specify the right host or port?

worker-1 $: kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.3
Kustomize Version: v4.5.4
The connection to the server localhost:8080 was refused - did you specify the right host or port?

worker-2 $: kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.3
Kustomize Version: v4.5.4
The connection to the server localhost:8080 was refused - did you specify the right host or port?

```

Don't worry about the error at the end as it is expected. We have not set anything up yet!

Prev: [Compute Resources](02-compute-resources.md)<br>
Next: [Certificate Authority](04-certificate-authority.md)
