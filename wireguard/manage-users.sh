#!/bin/bash

# WireGuard Peers Management Script
# Usage: ./manage-users.sh add|remove <peer_name>
# Author: rmnetwork2020-arch

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 add|remove <peer_name>"
    exit 1
fi

ACTION=$1
PEER_NAME=$2
CONFIG_DIR="/etc/wireguard"
PRIVATE_KEYS_DIR="/etc/wireguard/keys"

# Function to generate a key pair
generate_keys() {
    PRIVATE_KEY=$(wg genkey)
    PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)
    echo "$PRIVATE_KEY:$PUBLIC_KEY"
}

# Function to add a new peer
add_peer() {
    read PRIVATE_KEY PUBLIC_KEY <<< $(generate_keys)
    echo "[Peer]" >> "$CONFIG_DIR/wg0.conf"
    echo "PublicKey = $PUBLIC_KEY" >> "$CONFIG_DIR/wg0.conf"
    echo "AllowedIPs = 10.0.0.2/32" >> "$CONFIG_DIR/wg0.conf" # Change IP as necessary
    echo "$PEER_NAME added successfully with key pair."
}

# Function to remove a peer
remove_peer() {
    sed -i "/$PEER_NAME/,/\[Peer\]/{d}" "$CONFIG_DIR/wg0.conf"
    echo "$PEER_NAME removed successfully."
}

# Execute action
case $ACTION in
    add)
        add_peer
        ;; 
    remove)
        remove_peer
        ;; 
    *)
        echo "Invalid action! Use 'add' or 'remove'."
        exit 1
        ;;
esac

exit 0