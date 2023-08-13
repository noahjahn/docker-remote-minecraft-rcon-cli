#!/bin/bash

export UID
docker compose down --remove-orphans
find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
