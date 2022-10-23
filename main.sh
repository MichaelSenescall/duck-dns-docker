INTERVAL=${INTERVAL:-"30m"}

if [ -z "$DOMAINS" ]; then
	echo "DOMAINS missing"
	exit 1
fi

if [ -z "${TOKEN}" ]; then
	echo "TOKEN missing"
	exit 1
fi

while true; do
	echo "Starting loop..."

	URL="https://www.duckdns.org/update?domains=${DOMAINS}&token=${TOKEN}"

	IPV4=$(curl -4 ifconfig.io)
	IPV6=$(curl -6 ifconfig.io)

	if [ -z "${IPV4}" || "${IPV4}" = "curl: (7) Couldn't connect to server" ]; then
		echo "No IPv4 address found."
	else
		echo "IPv4 Found: ${IPV4}"
		URL="${URL}&ip=${IPV4}"
	fi

	if [ -z "${IPV6}" || "${IPV6}" = "curl: (7) Couldn't connect to server" ]; then
		echo "No IPv6 address found."
	else
		echo "IPv6 Found: ${IPV6}"
		URL="${URL}&ipv6=${IPV6}"
	fi
	
	echo "Calling URL: ${URL}"
	RESPONSE=$(curl -s -k "${URL}" & wait)
	echo "Duck DNS response: ${RESPONSE}"

	# Sleep and loop
	sleep $INTERVAL & wait
done
