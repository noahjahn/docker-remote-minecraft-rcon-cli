#!/bin/bash

__file_exists() {
    test -f "$1"
}

HOST_PORT=8055
if [ -n "$1" ]; then
    HOST_PORT="$1"
fi

export UID HOST_PORT
if ! __file_exists ".env"; then
    echo "Please create the .env file"
    echo "Example: "
    echo "cp .env.example .env"
    exit 1
fi

mkdir -p node_modules

docker compose pull || exit 1
docker compose build || exit 1

./npm install || { docker compose down --remove-orphans; exit 1; }

docker compose up -d --wait || { docker compose down --remove-orphans; exit 1; }

./node ace migration:run || { docker compose down --remove-orphans; exit 1; }

docker compose logs -f || { docker compose down --remove-orphans; exit 0; }
