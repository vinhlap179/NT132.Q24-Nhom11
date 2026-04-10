#!/usr/bin/env bash
configure_ospf() {
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



# Configure each router with respective networks
configure_ospf "router1" "10.10.10.0/24" "10.10.11.2/29" "10.10.11.10/29"
configure_ospf "router2" "10.10.11.3/29" "10.10.11.18/29"
configure_ospf "router3" "10.10.11.11/29" "10.10.11.26/29"
configure_ospf "router4" "10.10.11.19/29" "10.10.11.27/29" "30.30.30.2/29"
configure_ospf "router5" "30.30.30.3/29" "20.20.21.2/29" "20.20.21.10/29"
configure_ospf "router6" "20.20.21.3/29" "20.20.21.18/29"
configure_ospf "router7" "20.20.21.11/29" "20.20.21.26/29"
configure_ospf "router8" "20.20.21.19/29" "20.20.21.27/29" "20.20.20.0/24"

echo "OSPF configuration completed for all routers."

#update_timers "router1"
#update_timers "router2"
#update_timers "router3"
#update_timers "router4"
#update_timers "router5"
#update_timers "router6"
#update_timers "router7"
#update_timers "router8"
#
#echo "RIP timers updated for all routers."
