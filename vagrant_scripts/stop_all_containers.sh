#!/usr/bin/env bash
function stop {
  CONTAINER_IDS=$(docker ps -q)
  if [[ -z $CONTAINER_IDS ]];then
    echo "     no containers to stop"
    return
  fi
  echo "       container ids: $CONTAINER_IDS"
  docker kill $CONTAINER_IDS | xargs docker rm
}

echo "-----> stoppping all containers"
stop
