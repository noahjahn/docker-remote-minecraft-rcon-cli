#!/bin/bash

export UID

ls -A node_modules &> /dev/null

if [ $? -ne 0 ]; then
  ./npm install
fi

docker compose run --rm --entrypoint=node node $@
