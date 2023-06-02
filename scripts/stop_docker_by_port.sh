#!/usr/bin/env bash

port=$1

RED='\033[0;91m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo "" # empty first line

if [ -z $port ]; then
  echo -e "  ${YELLOW}Please specify a port to a running docker container!${RESET}"
  exit 0
fi

port_is_number_regex='^[0-9]+$'
if ! [[ $port =~ $port_is_number_regex ]]; then
  echo -e "  ${RED}Port can only be of type number${RESET}" >&2
  exit 1
fi

num_results=0
no_results=0
SECONDS=0

for id in $(docker ps -q); do
  ((num_results += 1))
  if [[ $(docker port "${id}") == *:"${port}"* ]]; then
    echo -e "  Stopping container ${GREEN}${id}${RESET}"
    fin_id=$(docker stop "${id}")
        docker rm "${id}"
    if [ $fin_id == $id ]; then
      echo -e "  ${GREEN}Done${RESET} in ${SECONDS}s"
    fi
  else
    ((no_results += 1))
  fi
done

if [ $num_results -eq $no_results ]; then
  echo -e "  No running container found with port ${YELLOW}${port}${RESET}"
fi
