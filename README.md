docker-riak-2.0
===========

Builds a docker image for Riak.

# NOTE

This Dockerfile was built for a beta version of Riak 2.0. Use at your own risk

# Usage

```bash
# start a solo riak server
vagrant up alpha --provision
# verify server is online
curl 192.168.50.10:8098/ping

# start a second server that will automatically join the first and form a cluster
vagrant up beta --provision
# verify server is online
curl 192.168.50.20:8098/ping
```

After both servers are running, try loading some data into a single server and verify that it gets replicated to the second

# Building

To build a docker image, use the included Vagrantfile to launch up a virtual machine with docker already installed. The Vagrantfile uses the [vagrant docker provisioner](http://docs.vagrantup.com/v2/provisioning/docker.html) to install docker

**Requirements**

* [Vagrant](http://www.vagrantup.com/)

To launch the vagrant virtual machine

```bash
cd /path/to/this/repo
vagrant up alpha
```

Once the virtual machine is running you can test out the `Dockerfile` via

```bash
# log into the virtual machine
vagrant ssh
# go to the mounted shared folder
cd /vagrant/app

# build a docker image from the Dockerfile
docker build -t riak .

# ensure that the image exists, you should see the `riak` image in the list output
docker images

# run the container, mapping ports on the host virtual machine to the same ports inside the container
ID=$(docker run -d -e RIAK_NODE_NAME=riak@"192.168.10.10" -e RIAK_JOIN_NODE="riak@192.168.10.20" -p 2222:22 -p 8087:8087 -p 8098:8098 -p 8000:8000 -p 4369:4369 -p 8099:8099 -p 8000:8000 riak)

# wait a few seconds and then check the logs on the container, you should see the output from riak starting up.
docker logs $ID

# connect to the riak service running in the container via riak http interface
curl "http://localhost:8098"

You can connect to the running container via the mapped ssh port
ssh -p 2222 root@localhost
# password: basho
```

## Multi-node cluster configuration

The riak server container is designed to be run in a cluster. You must specify the following environment variables when running in a cluster

### `RIAK_NODE_NAME`

The `RIAK_NODE_NAME` environment variable should be set to the ip address of the host machine. For example, if the host machine is running on `192.168.10.10`, then `RIAK_NODE_NAME="riak@192.168.10.10"`

### `RIAK_JOIN_NODE`

The `RIAK_JOIN_NODE` environment variable should be set to another running riak node. If this environment variable is set, after the container starts, it will automatically join the cluster by connecting to the riak node at `RIAK_JOIN_NODE` address.


# Notes

See `./vagrant_scripts/solo.sh` and `./vagrant_scripts/join.sh` to see what all the port mappings in the `docker run ...` command are about.

* Backend: The riak container is configured to use the [leveldb backend](http://docs.basho.com/riak/latest/ops/advanced/backends/leveldb/).
* Search: The riak container is configured with yokozuna enabled
