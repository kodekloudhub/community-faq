#!/usr/bin/env bash
#
# This script sets PRIMARY_IP shell variable to the IP
# of the interface used to communicate with the outside world.
# Also provides a script that vagrant can run to obtain this address.

IP_NW=$1
BUILD_MODE=$2

# DISTRO will be "debian" or "rhel"
DISTRO=$(. /etc/os-release ; echo $ID_LIKE | cut -d ' ' -f 1)

logger -p local0.notice -t "setup-ip.sh" "IP_NW: ${IP_NW}, BUILD_MODE=${BUILD_MODE}"

if [ "$BUILD_MODE" = "BRIDGE" ]
then
    # Determine machine IP from route table -
    # Interface that routes to default GW that isn't on the NAT network.
    MY_IP="$(ip route | grep default | grep -Pv '10\.\d+\.\d+\.\d+' | awk '{ print $9 }')"

    # From this, determine the network (which for average broadband we assume is a /24)
    MY_NETWORK=$(echo $MY_IP | awk 'BEGIN {FS="."} ; { printf("%s.%s.%s", $1, $2, $3) }')
else
    # Determine machine IP from route table -
    # Interface that is connected to the NAT network.
    MY_IP="$(ip route | awk '/'${IP_NW}'/ { print $9 }')"
    MY_NETWORK=$IP_NW
fi

echo "PRIMARY_IP=${MY_IP}" >> /etc/environment

cat <<EOF > /usr/local/bin/public-ip
#!/usr/bin/env sh
echo -n $MY_IP
EOF

chmod +x /usr/local/bin/public-ip
