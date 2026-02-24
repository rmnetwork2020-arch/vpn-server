# VPN Server Setup Documentation

## Introduction
This document provides comprehensive instructions for setting up a VPN server using two of the most popular VPN protocols: OpenVPN and WireGuard. Follow the steps for your preferred protocol.

## Table of Contents
- [OpenVPN Setup](#openvpn-setup)
- [WireGuard Setup](#wireguard-setup)

---

## OpenVPN Setup
### Prerequisites
- A server running a compatible operating system (e.g., Ubuntu, CentOS).
- Root access or sudo privileges.

### Installation
1. **Update the package list:**
   ```bash
   sudo apt update
   ```

2. **Install OpenVPN and Easy-RSA:**
   ```bash
   sudo apt install openvpn easy-rsa
   ```

3. **Set up the CA directory:**
   ```bash
   make-cadir ~/openvpn-ca
   cd ~/openvpn-ca
   ```

4. **Configure vars':**
   Edit the vars file with your preferred text editor and customize your organization information.

5. **Build the CA:**
   ```bash
   source vars
   ./clean-all
   ./build-ca
   ```

6. **Create the server certificate and key:**
   ```bash
   ./build-key-server server
   ```

7. **Generate Diffie-Hellman parameters:**
   ```bash
   ./build-dh
   ```

### Configuration
- Edit the server configuration file located in `/etc/openvpn/server.conf`.
- Configure necessary options like port, protocol, and server.

### Start OpenVPN
```bash
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server
```

## WireGuard Setup
### Prerequisites
- A server with a modern Linux distribution.

### Installation
1. **Install WireGuard:**
   ```bash
   sudo apt install wireguard
   ```

### Configuration
2. **Generate keys:**
   ```bash
   umask 077
   wg genkey | tee privatekey | wg pubkey > publickey
   ```

3. **Configure WireGuard:**
   Create a `.conf` file in `/etc/wireguard/wg0.conf` and set up the configuration options.

4. **Start WireGuard:**
   ```bash
   sudo wg-quick up wg0
   ```
   To automatically start on boot, enable the service:
   ```bash
   sudo systemctl enable wg-quick@wg0
   ```

## Conclusion
This document provides a basic overview of setting up OpenVPN and WireGuard. Always refer to the respective official documentation for the most accurate and up-to-date information.