#!/bin/bash

# This script will install OpenVPN and set it up on your Arch Linux system.

# Update the system
echo "Updating system..."
sudo pacman -Syu

# Install required packages
echo "Installing OpenVPN and easy-rsa..."
sudo pacman -S --noconfirm openvpn easy-rsa

# Set up easy-rsa
echo "Setting up easy-rsa..."
make-cadir ~/easy-rsa
dotenv ~/easy-rsa

# Move to easy-rsa directory
cd ~/easy-rsa

# Edit vars file to set up your own CA settings
# nano vars # Uncomment to edit with your desired settings

# Build the CA
./easyrsa init-pki
./easyrsa build-ca

# Generate server certificate and key
./easyrsa gen-req server nopass
./easyrsa sign-req server server

# Generate Diffie-Hellman parameters
./easyrsa gen-dh

# Generate server certificate
openvpn --genkey --secret ta.key

# Move generated files to the OpenVPN directory
sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key /etc/openvpn/
sudo cp ta.key /etc/openvpn/
sudo cp pki/dh.pem /etc/openvpn/

# Set up the server configuration file
sudo bash -c 'cat <<EOF > /etc/openvpn/server.conf
port 1194
proto udp
dev tun
server 10.8.0.0 255.255.255.0
ca ca.crt
cert server.crt
key server.key
dh dh.pem
tls-auth ta.key 0
cipher AES-256-CBC
comp-lzo
persist-key
persist-tun
user nobody
group nogroup
keepalive 10 120
status openvpn-status.log
verb 3
EOF'

# Start and enable the OpenVPN service
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server

echo "OpenVPN installation and setup completed!"