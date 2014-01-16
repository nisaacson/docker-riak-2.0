#!/usr/bin/env bash

source /etc/default/riak              \
  && echo "-----> Set node name"      \
  && echo "       Riak node name set" \
  && /etc/default/set_node_name.sh    \
  && echo "-----> Start riak node"    \
  && /opt/riak/bin/riak start         \
  && echo "       Riak node started"  \
  && echo "-----> Join cluster"       \
  && /etc/default/join_cluster.sh      \
  && echo "-----> Start riak console" \
  && /opt/riak/bin/riak attach
