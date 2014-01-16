###################
# Run a riak server inside a docker container.
#
# Usage:
# HOST_IP="192.168.50.10
# EXISTINGING_SERVER_IN_CLUSTER_IP="192.168.50.10
# ./join.sh $HOST_IP $EXISTING_SERVER_IN_CLUSTER_IP
###################

echo "-----> Run solo riak server in docker container"

function validate_ip_set {
  if [[ -z $HOST_IP ]]; then
    echo "HOST_IP env variable is required but not set" >&2
    exit 1
  fi
}

HOST_IP=$1
validate_ip_set
SSH_PORT=1111
RIAK_HTTP_PORT=8098
RIAK_PB_PORT=8087

YOKOZUNA_SOLR_PORT=8093
YOKOZUNA_SOLR_JMX_PORT=8985

ERLANG_EPMD_PORT=4369
RIAK_HANDOFF_PORT=8099
EPMD_PORT_1=8000

if [[ -z $HOST_IP ]]; then
  echo "HOST_IP env variable is required but not set" >&2
  exit 1
fi

RIAK_NODE_NAME="riak@$HOST_IP"

COMMAND="docker run \
  -d \
  -e RIAK_NODE_NAME=$RIAK_NODE_NAME \
  -p $SSH_PORT:22 \
  -p $RIAK_PB_PORT:$RIAK_PB_PORT \
  -p $RIAK_HTTP_PORT:$RIAK_HTTP_PORT \
  -p $YOKOZUNA_SOLR_PORT:$YOKOZUNA_SOLR_PORT \
  -p $YOKOZUNA_SOLR_JMX_PORT:$YOKOZUNA_SOLR_JMX_PORT \
  -p $ERLANG_EPMD_PORT:$ERLANG_EPMD_PORT \
  -p $RIAK_HANDOFF_PORT:$RIAK_HANDOFF_PORT \
  -p $EPMD_PORT_1:$EPMD_PORT_1 \
  -t riak"
echo "       solo command: $COMMAND"
ID=$($COMMAND)
if [[ $? -ne 0 ]]; then
  echo "failed to start container" >&2
  exit 1
fi
echo "       solo docker container running, id: $ID\n\n"

