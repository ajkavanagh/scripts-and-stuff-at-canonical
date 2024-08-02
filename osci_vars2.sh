export TEST_HTTP_PROXY="http://squid.internal:3128"
export OS_TEST_HTTP_PROXY="http://squid.internal:3128"

export AMULET_HTTP_PROXY=http://squid.internal:3128
export AMULET_HTTPS_PROXY=http://squid.internal:3128
export AMULET_OS_VIP="172.20.1.131"
export AMULET_OS_VIP00="172.20.1.131"

export MOJO_OS_VIP01="172.20.1.131"
export MOJO_OS_VIP02="172.20.1.132"
export MOJO_OS_VIP03="172.20.1.133"
export MOJO_OS_VIP04="172.20.1.134"
export MOJO_OS_VIP05="172.20.1.135"
export MOJO_OS_VIP06="172.20.1.136"
export MOJO_OS_VIP07="172.20.1.137"
export MOJO_OS_VIP08="172.20.1.138"
export MOJO_OS_VIP09="172.20.1.139"
export MOJO_OS_VIP10="172.20.1.140"
export MOJO_OS_VIP11="172.20.1.141"
export MOJO_OS_VIP12="172.20.1.142"
export MOJO_OS_VIP13="172.20.1.143"
export MOJO_OS_VIP14="172.20.1.144"
export MOJO_OS_VIP15="172.20.1.145"
export MOJO_OS_VIP16="172.20.1.146"
export MOJO_OS_VIP17="172.20.1.147"
export MOJO_OS_VIP18="172.20.1.148"
export MOJO_OS_VIP19="172.20.1.149"
export MOJO_OS_VIP20="172.20.1.150"

export OS_VIP00=$MOJO_OS_VIP01
export OS_VIP01=$MOJO_OS_VIP02
export OS_VIP02=$MOJO_OS_VIP03
export OS_VIP03=$MOJO_OS_VIP04
export OS_VIP04=$MOJO_OS_VIP05
export OS_VIP05=$MOJO_OS_VIP06
export OS_VIP06=$MOJO_OS_VIP07
export OS_VIP07=$MOJO_OS_VIP08
export OS_VIP08=$MOJO_OS_VIP09
export OS_VIP09=$MOJO_OS_VIP10
export OS_VIP10=$MOJO_OS_VIP11
export OS_VIP11=$MOJO_OS_VIP12
export OS_VIP12=$MOJO_OS_VIP13
export OS_VIP13=$MOJO_OS_VIP14
export OS_VIP14=$MOJO_OS_VIP15
export OS_VIP15=$MOJO_OS_VIP16
export OS_VIP16=$MOJO_OS_VIP17
export OS_VIP17=$MOJO_OS_VIP18
export OS_VIP18=$MOJO_OS_VIP19
export OS_VIP19=$MOJO_OS_VIP20

export TEST_VIP=$MOJO_OS_VIP01
export TEST_VIP00=$MOJO_OS_VIP01
export TEST_VIP01=$MOJO_OS_VIP02
export TEST_VIP02=$MOJO_OS_VIP03
export TEST_VIP03=$MOJO_OS_VIP04
export TEST_VIP04=$MOJO_OS_VIP05
export TEST_VIP05=$MOJO_OS_VIP06
export TEST_VIP06=$MOJO_OS_VIP07
export TEST_VIP07=$MOJO_OS_VIP08
export TEST_VIP08=$MOJO_OS_VIP09
export TEST_VIP09=$MOJO_OS_VIP10
export TEST_VIP10=$MOJO_OS_VIP11
export TEST_VIP11=$MOJO_OS_VIP12
export TEST_VIP12=$MOJO_OS_VIP13
export TEST_VIP13=$MOJO_OS_VIP14
export TEST_VIP14=$MOJO_OS_VIP15
export TEST_VIP15=$MOJO_OS_VIP16
export TEST_VIP16=$MOJO_OS_VIP17
export TEST_VIP17=$MOJO_OS_VIP18
export TEST_VIP18=$MOJO_OS_VIP19
export TEST_VIP19=$MOJO_OS_VIP20

export CIDR_EXT="172.20.1.0/24"
export default_gateway="172.20.1.1"
export external_net_cidr="172.20.1.0/24"
export external_dns="10.245.160.2"
export start_floating_ip="172.20.1.200"
export end_floating_ip="172.20.1.249"


_OS_REGION_NAME=$(env | grep OS_REGION_NAME | cut -d "=" -f 2)
# exit if this isn't running against serverstack
if [[ "xxx$_OS_REGION_NAME" != "xxxserverstack" ]]; then
	echo "OS_* vars aren't for serverstack"
fi

# for running things as an OSCI bastion
NETWORK_ID=df6496d0-71f2-4bb2-8f4d-2b5af0043c91
NETWORK_NAME=oscifi2
NETWORK_CIDR=172.20.1.0/24

function no_ipcalc {
 echo "Install ipcalc: sudo apt install ipcalc"
 exit 2
}
ipcalc > /dev/null 2>&1 || no_ipcalc

CIDR_END=$(ipcalc $NETWORK_CIDR | awk '/^HostMax: /{ print $2 }')
GATEWAY=$(ipcalc $NETWORK_CIDR | awk '/^HostMin: /{ print $2 }')
NAME_SERVER=$(echo $GATEWAY | sed "s/\.1$/.2/g")
FIP_START=$(echo $CIDR_END | sed "s/254/150/g")
FIP_END="$(echo $CIDR_END | sed 's/254/230/g')"

ROUTER_ID=$(openstack router list | grep _router | awk '{print $2}')
NETWORK_ID=$(openstack network show $NETWORK_NAME -c id -f value)


#echo "Ensure that the following is set before bootstrap juju"
export NETWORK_NAME=$NETWORK_NAME
export NETWORK_ID=$NETWORK_ID

#echo "Create variables export file for functest runs. Add this to .bashrc or a file that can be sourced before each funtest run:"
export TEST_NET_ID=$NETWORK_ID
export TEST_CIDR_EXT=$NETWORK_CIDR
export TEST_CIDR_END=$CIDR_END
export TEST_FIP_RANGE="${FIP_START}:${FIP_END}"
export TEST_GATEWAY=$GATEWAY
export TEST_NAME_SERVER=10.245.160.2

export TEST_DEPLOY_TIMEOUT=7200

# also set feature flags
export TEST_ZAZA_BUG_LP1987332=1
#echo
#echo
#echo "Run a functest with the above sourced to test as if on OSCI"
#echo "tox -e func-smoke"

