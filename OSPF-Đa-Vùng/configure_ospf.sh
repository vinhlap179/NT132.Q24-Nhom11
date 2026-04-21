#!/usr/bin/env bash
configure_ospf_area1() {
    local container_name=$1
    shift
    local networks=("$@")


    # Add each network individually to avoid command syntax issues
    for net in "${networks[@]}"; do
        docker exec -it "$container_name" vtysh -c "configure terminal" -c "router ospf" -c "network ${net%} area 1"
    done

    # Exit and save configuration
    docker exec -it "$container_name" vtysh -c "write memory"
}
configure_ospf_area2() {
    local container_name=$1
    shift
    local networks=("$@")


    # Add each network individually to avoid command syntax issues
    for net in "${networks[@]}"; do
        docker exec -it "$container_name" vtysh -c "configure terminal" -c "router ospf" -c "network ${net%} area 2"
    done

    # Exit and save configuration
    docker exec -it "$container_name" vtysh -c "write memory"
}
configure_abr() {
    local container_name=$1
    shift


    docker exec -it "$container_name" vtysh -c "configure terminal" -c "router ospf" -c "ospf abr-type standard"

    # Exit and save configuration
    docker exec -it "$container_name" vtysh -c "write memory"
}



# Configure each router with respective networks
configure_ospf_area1 "router1" "10.10.10.0/24" "10.10.11.2/29" "10.10.11.10/29"
configure_ospf_area1 "router2" "10.10.11.3/29" "10.10.11.18/29"
configure_ospf_area1 "router3" "10.10.11.11/29" "10.10.11.26/29"
configure_ospf_area1 "router4" "10.10.11.19/29" "10.10.11.27/29" 
configure_ospf_area2 "router4" "30.30.30.2/29"
configure_ospf_area2 "router5" "30.30.30.3/29" "20.20.21.2/29" "20.20.21.10/29"
configure_ospf_area2 "router6" "20.20.21.3/29" "20.20.21.18/29"
configure_ospf_area2 "router7" "20.20.21.11/29" "20.20.21.26/29"
configure_ospf_area2 "router8" "20.20.21.19/29" "20.20.21.27/29" "20.20.20.0/24"

#configure_abr "router4"
echo "OSPF configuration completed for all routers."

