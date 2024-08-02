# Set these values
NETWORK_NAME=oscify2
NETWORK_CIDR=172.20.1.0/24

if [ -z "$OS_REGION_NAME" ]; then
   echo "Source your ServerStack openrc before running this script."
   exit 1
fi

function no_ipcalc {
 echo "Install ipcalc: sudo apt install ipcalc"
 exit 2
}
ipcalc > /dev/null 2>&1 || no_ipcalc

# Automatic variables
CIDR_END=$(ipcalc $NETWORK_CIDR | awk '/^HostMax: /{ print $2 }')
GATEWAY=$(ipcalc $NETWORK_CIDR | awk '/^HostMin: /{ print $2 }')
NAME_SERVER=$(echo $GATEWAY | sed "s/\.1$/.2/g")
FIP_START=$(echo $CIDR_END | sed "s/254/150/g")
FIP_END="$(echo $CIDR_END | sed 's/254/230/g')"

# Create the network and add an interface to the main router in the subnet
ROUTER_ID=$(openstack router list | grep _router | awk '{print $2}')
openstack network show $NETWORK_NAME &>/dev/null || openstack network create --internal --disable-port-security $NETWORK_NAME
NETWORK_ID=$(openstack network show $NETWORK_NAME -c id -f value)
openstack subnet show ${NETWORK_NAME}_subnet &>/dev/null || openstack subnet create --subnet-range $NETWORK_CIDR --dhcp --network $NETWORK_ID ${NETWORK_NAME}_subnet
openstack router add subnet $ROUTER_ID ${NETWORK_NAME}_subnet ||:

echo
echo
echo "Run the following to bootstrap juju"
echo "export NETWORK_ID=$NETWORK_ID"
echo "/your/path/to/charm-test-infra/juju-openstack-controller-example.sh"
echo
echo
echo "Create variables export file for functest runs. Add this to .bashrc or a file that can be sourced before each funtest run:"
echo "export TEST_NET_ID=$NETWORK_ID"
echo "export TEST_CIDR_EXT=$NETWORK_CIDR"
echo "export TEST_CIDR_END=$CIDR_END"
echo "export TEST_FIP_RANGE='${FIP_START}:${FIP_END}'"
echo "export TEST_GATEWAY=$GATEWAY"
echo "export TEST_NAME_SERVER=$NAME_SERVER"
echo
echo
echo "Run a functest with the above sourced to test as if on OSCI"
echo "tox -e func-smoke"
