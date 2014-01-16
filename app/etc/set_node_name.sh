#!/usr/bin/env bash

sed -i.bak s/RIAK_NODE_NAME/${RIAK_NODE_NAME}/ /opt/riak/etc/riak.conf > /dev/null
