#!/usr/bin/env bash

###################
# Run a riak server inside a docker container.
# Once the container is running, join to an existing riak cluser
#
# Usage:
# HOST_IP="192.168.50.10
# EXISTINGING_SERVER_IN_CLUSTER_IP="192.168.50.10
# ./join.sh $HOST_IP $EXISTING_SERVER_IN_CLUSTER_IP
###################

echo "-----> ./scripts/join.sh: Run riak server in docker container and join to cluster"

function validate_ip_set {
  if [[ -z $HOST_IP ]]; then
    echo "HOST_IP env variable is required but not set" >&2
    exit 1
  fi

  if [[ -z $JOIN_IP ]]; then
    echo "JOIN_IP env variable is required but not set" >&2
    exit 1
  fi
}

# cd /vagrant/app && docker build -t riak .
HOST_IP=$1
JOIN_IP=$2
validate_ip_set

SSH_PORT=1111
RIAK_HTTP_PORT=8098
RIAK_PB_PORT=8087

YOKOZUNA_SOLR_PORT=8093
YOKOZUNA_SOLR_JMX_PORT=8985

ERLANG_EPMD_PORT=4369
RIAK_HANDOFF_PORT=8099
EPMD_PORT_1=8000

RIAK_NODE_NAME="riak@$HOST_IP"
RIAK_JOIN_NODE="riak@$JOIN_IP"
COMMAND="docker run \
  -d \
  -e RIAK_NODE_NAME=$RIAK_NODE_NAME \
  -e RIAK_JOIN_NODE=$RIAK_JOIN_NODE \
  -p $SSH_PORT:22 \
  -p $RIAK_PB_PORT:$RIAK_PB_PORT \
  -p $RIAK_HTTP_PORT:$RIAK_HTTP_PORT \
  -p $YOKOZUNA_SOLR_PORT:$YOKOZUNA_SOLR_PORT \
  -p $YOKOZUNA_SOLR_JMX_PORT:$YOKOZUNA_SOLR_JMX_PORT \
  -p $ERLANG_EPMD_PORT:$ERLANG_EPMD_PORT \
  -p $RIAK_HANDOFF_PORT:$RIAK_HANDOFF_PORT \
  -p $EPMD_PORT_1:$EPMD_PORT_1 \
  -t riak"

echo "       join command: $COMMAND"
ID=$($COMMAND)
if [[ $? -ne 0 ]]; then
  echo "failed to start container" >&2
  exit 1
fi
echo "       join docker container running, id: $ID\n\n"

