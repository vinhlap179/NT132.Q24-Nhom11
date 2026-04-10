#!/usr/bin/env bash

docker build -t host -f Dockerfile_host1 .
docker build -t router_frr -f Dockerfile_router .
