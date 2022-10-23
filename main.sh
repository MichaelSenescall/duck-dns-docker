INTERVAL=${INTERVAL:-"30m"}
USE_IPV4=${USE_IPV4:-"yes"}
USE_IPV6=${USE_IPV6:-"no"}

if [ -z "$DOMAINS" ]; then
	echo "DOMAINS missing"
	exit 1
fi

if [ -z "${TOKEN}" ]; then
	echo "TOKEN missing"
	exit 1
fi

if [ "${USE_IPV4}" = "no" ] && [ "${USE_IPV6}" = "no" ]; then
	echo "At least one of USE_IPV4 and USE_IPV6 must be set to 'yes'"
	exit 1
fi

while true; do
	echo "Starting loop..."

	URL="https://www.duckdns.org/update?domains=${DOMAINS}&token=${TOKEN}"

	# IPv4
	if [ "${USE_IPV4,,}" = "yes" ]; then
		IPV4=$(curl -4 ifconfig.io)
		echo "IPv4: ${IPV4}"
		URL="${URL}&ip=${IPV4}"
	fi

	# IPv6
	if [ "${USE_IPV6,,}" = "yes" ]; then
		IPV6=$(curl -6 ifconfig.io)
		echo "IPv6: ${IPV6}"
		URL="${URL}&ipv6=${IPV6}"
	fi
	
	echo "Calling URL: ${URL}"
	RESPONSE=$(curl -s -k "${URL}" & wait)
	echo "Duck DNS response: ${RESPONSE}"

	# Sleep and loop
	sleep $INTERVAL & wait
done
