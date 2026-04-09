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

docker network create --subnet=10.10.10.0/24 -d macvlan --internal net1
docker network create --subnet=20.20.20.0/24 -d macvlan --internal net2
docker network create --subnet=10.10.11.0/29 -d macvlan --internal r1-r2
docker network create --subnet=10.10.11.8/29 -d macvlan --internal r1-r3
docker network create --subnet=10.10.11.16/29 -d macvlan --internal r2-r4
docker network create --subnet=10.10.11.24/29 -d macvlan --internal r3-r4
docker network create --subnet=30.30.30.0/29 -d macvlan --internal r4-r5
docker network create --subnet=20.20.21.0/29 -d macvlan --internal r5-r6
docker network create --subnet=20.20.21.8/29 -d macvlan --internal r5-r7
docker network create --subnet=20.20.21.16/29 -d macvlan --internal r6-r8
docker network create --subnet=20.20.21.24/29 -d macvlan --internal r7-r8

docker run -d --name host1 -h host1 --cap-add=NET_ADMIN host
docker network connect --ip 10.10.10.10 net1 host1

docker run -d --name host2 -h host2 --cap-add=NET_ADMIN host
docker network connect --ip 20.20.20.20 net2 host2

docker run -d --name router1 -h router1 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 10.10.10.254 net1 router1
docker network connect --ip 10.10.11.2 r1-r2 router1
docker network connect --ip 10.10.11.10 r1-r3 router1

docker run -d --name router2 -h router2 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 10.10.11.3 r1-r2 router2
docker network connect --ip 10.10.11.18 r2-r4 router2

docker run -d --name router3 -h router3 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 10.10.11.11 r1-r3 router3
docker network connect --ip 10.10.11.26 r3-r4 router3

docker run -d --name router4 -h router4 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 10.10.11.19 r2-r4 router4
docker network connect --ip 10.10.11.27 r3-r4 router4
docker network connect --ip 30.30.30.2 r4-r5 router4

docker run -d --name router5 -h router5 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 30.30.30.3 r4-r5 router5
docker network connect --ip 20.20.21.2 r5-r6 router5
docker network connect --ip 20.20.21.10 r5-r7 router5

docker run -d --name router6 -h router6 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 20.20.21.3 r5-r6 router6
docker network connect --ip 20.20.21.18 r6-r8 router6

docker run -d --name router7 -h router7 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 20.20.21.11 r5-r7 router7
docker network connect --ip 20.20.21.26 r7-r8 router7

docker run -d --name router8 -h router8 --cap-add=NET_ADMIN --cap-add=SYS_ADMIN router_frr
docker network connect --ip 20.20.21.19 r6-r8 router8
docker network connect --ip 20.20.21.27 r7-r8 router8
docker network connect --ip 20.20.20.254 net2 router8

docker exec -ti host1 bash -c "route del default gw 172.17.0.1"
docker exec -ti host1 bash -c "route add default gw 10.10.10.254"
docker exec -ti host2 bash -c "route del default gw 172.17.0.1"
docker exec -ti host2 bash -c "route add default gw 20.20.20.254"
docker exec -ti router1 bash -c "route del default gw 172.17.0.1"
docker exec -ti router2 bash -c "route del default gw 172.17.0.1"
docker exec -ti router3 bash -c "route del default gw 172.17.0.1"
docker exec -ti router4 bash -c "route del default gw 172.17.0.1"
docker exec -ti router5 bash -c "route del default gw 172.17.0.1"
docker exec -ti router6 bash -c "route del default gw 172.17.0.1"
docker exec -ti router7 bash -c "route del default gw 172.17.0.1"
docker exec -ti router8 bash -c "route del default gw 172.17.0.1"

