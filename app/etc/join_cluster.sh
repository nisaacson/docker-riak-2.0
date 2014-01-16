#!/usr/bin/env bash

function wait_for_node {
  echo "wait for riak node"
  while :
  do
    /opt/riak/bin/riak ping
    EXIT_CODE=$?
    echo "exit code $EXIT_CODE"
    if [[ $EXIT_CODE -eq 0 ]]; then
      echo "riak node online"
      break
    fi
    sleep "0.5s"
  done
}

function join {
  if [[ -z $RIAK_JOIN_NODE ]]; then
     echo "RIAK_JOIN_NODE environment variable not set, skip joining cluster"
     return
  fi
  echo "Join cluster now"
  # set the plan
  echo "create cluster join plan"
  opt/riak/bin/riak-admin cluster join $RIAK_JOIN_NODE

  # display the plan
  echo "display cluster join plan"
  opt/riak/bin/riak-admin cluster plan
  # commit the plan
  echo "commit cluster join plan"
  opt/riak/bin/riak-admin cluster commit
}

wait_for_node
join

