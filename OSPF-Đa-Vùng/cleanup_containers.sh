#!/usr/bin/env bash

docker stop host1
docker stop host2
docker stop router1
docker stop router2
docker stop router3
docker stop router4
docker stop router5
docker stop router6
docker stop router7
docker stop router8
docker rm router1
docker rm router2
docker rm router3
docker rm router4
docker rm router5
docker rm router6
docker rm router7
docker rm router8
docker rm host1
docker rm host2
docker network rm net1
docker network rm net2
docker network rm r1-r2
docker network rm r1-r3
docker network rm r2-r4
docker network rm r3-r4
docker network rm r4-r5
docker network rm r5-r6
docker network rm r5-r7
docker network rm r6-r8
docker network rm r7-r8
