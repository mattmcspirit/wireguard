#!/bin/bash

## unattended-upgrade
sudo apt-get update -y 
sudo unattended-upgrades -v

## IP Forwarding
sed -i -e 's/#net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i -e 's/#net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p

## Install WireGuard
sudo add-apt-repository ppa:wireguard/wireguard -y 
sudo apt-get update -y 
sudo apt-get install linux-headers-$(uname -r) -y
sudo apt-get install wireguard -y

## Install Resolvconf
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install resolvconf

## Configure WireGuard

# Generate security keys
mkdir /home/$2/WireGuardSecurityKeys
umask 077
wg genkey | tee /home/$2/WireGuardSecurityKeys/server_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/server_public_key
wg genpsk > /home/$2/WireGuardSecurityKeys/preshared_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_one_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_one_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_two_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_two_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_three_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_three_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_four_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_four_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_five_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_five_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_six_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_six_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_seven_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_seven_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_eight_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_eight_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_nine_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_nine_public_key
wg genkey | tee /home/$2/WireGuardSecurityKeys/client_ten_private_key | wg pubkey > /home/$2/WireGuardSecurityKeys/client_ten_public_key

# Generate configuration files
server_private_key=$(</home/$2/WireGuardSecurityKeys/server_private_key)
preshared_key=$(</home/$2/WireGuardSecurityKeys/preshared_key)
server_public_key=$(</home/$2/WireGuardSecurityKeys/server_public_key)
client_one_private_key=$(</home/$2/WireGuardSecurityKeys/client_one_private_key)
client_one_public_key=$(</home/$2/WireGuardSecurityKeys/client_one_public_key)
client_two_private_key=$(</home/$2/WireGuardSecurityKeys/client_two_private_key)
client_two_public_key=$(</home/$2/WireGuardSecurityKeys/client_two_public_key)
client_three_private_key=$(</home/$2/WireGuardSecurityKeys/client_three_private_key)
client_three_public_key=$(</home/$2/WireGuardSecurityKeys/client_three_public_key)
client_four_private_key=$(</home/$2/WireGuardSecurityKeys/client_four_private_key)
client_four_public_key=$(</home/$2/WireGuardSecurityKeys/client_four_public_key)
client_five_private_key=$(</home/$2/WireGuardSecurityKeys/client_five_private_key)
client_five_public_key=$(</home/$2/WireGuardSecurityKeys/client_five_public_key)
client_six_private_key=$(</home/$2/WireGuardSecurityKeys/client_six_private_key)
client_six_public_key=$(</home/$2/WireGuardSecurityKeys/client_six_public_key)
client_seven_private_key=$(</home/$2/WireGuardSecurityKeys/client_seven_private_key)
client_seven_public_key=$(</home/$2/WireGuardSecurityKeys/client_seven_public_key)
client_eight_private_key=$(</home/$2/WireGuardSecurityKeys/client_eight_private_key)
client_eight_public_key=$(</home/$2/WireGuardSecurityKeys/client_eight_public_key)
client_nine_private_key=$(</home/$2/WireGuardSecurityKeys/client_nine_private_key)
client_nine_public_key=$(</home/$2/WireGuardSecurityKeys/client_nine_public_key)
client_ten_private_key=$(</home/$2/WireGuardSecurityKeys/client_ten_private_key)
client_ten_public_key=$(</home/$2/WireGuardSecurityKeys/client_ten_public_key)

# Server Config
cat > /etc/wireguard/wg0.conf << EOF
[Interface]
Address = 10.10.10.1/24
SaveConfig = true
PrivateKey = $server_private_key
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey =  $client_one_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.101/32

[Peer]
PublicKey =  $client_two_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.102/32

[Peer]
PublicKey =  $client_three_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.103/32

[Peer]
PublicKey =  $client_four_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.104/32

[Peer]
PublicKey =  $client_five_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.105/32

[Peer]
PublicKey =  $client_six_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.106/32

[Peer]
PublicKey =  $client_seven_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.107/32

[Peer]
PublicKey =  $client_eight_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.108/32

[Peer]
PublicKey =  $client_nine_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.109/32

[Peer]
PublicKey =  $client_ten_public_key
PresharedKey = $preshared_key
AllowedIPs = 10.10.10.110/32
EOF

# Client Configs
cat > /home/$2/wg0-client-1.conf << EOF
[Interface]
PrivateKey = $client_one_private_key
Address = 10.10.10.101/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-1.conf

cat > /home/$2/wg0-client-2.conf << EOF
[Interface]
PrivateKey = $client_two_private_key
Address = 10.10.10.102/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-2.conf

cat > /home/$2/wg0-client-3.conf << EOF
[Interface]
PrivateKey = $client_three_private_key
Address = 10.10.10.103/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-3.conf

cat > /home/$2/wg0-client-4.conf << EOF
[Interface]
PrivateKey = $client_four_private_key
Address = 10.10.10.104/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-4.conf

cat > /home/$2/wg0-client-5.conf << EOF
[Interface]
PrivateKey = $client_five_private_key
Address = 10.10.10.105/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-5.conf

cat > /home/$2/wg0-client-6.conf << EOF
[Interface]
PrivateKey = $client_six_private_key
Address = 10.10.10.106/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-6.conf

cat > /home/$2/wg0-client-7.conf << EOF
[Interface]
PrivateKey = $client_seven_private_key
Address = 10.10.10.107/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-7.conf

cat > /home/$2/wg0-client-8.conf << EOF
[Interface]
PrivateKey = $client_eight_private_key
Address = 10.10.10.108/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-8.conf

cat > /home/$2/wg0-client-9.conf << EOF
[Interface]
PrivateKey = $client_nine_private_key
Address = 10.10.10.109/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-9.conf

cat > /home/$2/wg0-client-10.conf << EOF
[Interface]
PrivateKey = $client_ten_private_key
Address = 10.10.10.110/32
DNS = 1.1.1.1

[Peer]
PublicKey =  $server_public_key
PresharedKey = $preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $1:51820
PersistentKeepalive = 25
EOF

chmod go+r /home/$2/wg0-client-10.conf

## Firewall 
ufw allow 51820/udp
ufw allow 22/tcp
ufw enable

## WireGuard Service
wg-quick up wg0
systemctl enable wg-quick@wg0

## Upgrade
apt-get full-upgrade -y

## Reboot in 2 mins
shutdown -r 2