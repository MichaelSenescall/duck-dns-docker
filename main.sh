#!/bin/bash

# Initialise some default variables
INTERVAL=${INTERVAL:-"30m"}
USE_IPV4=${USE_IPV4:-"true"}
USE_IPV6=${USE_IPV6:-"false"}

# Make sure everything is lower case
USE_IPV4=$(echo "${USE_IPV4}" | awk '{print tolower($0)}')
USE_IPV6=$(echo "${USE_IPV6}" | awk '{print tolower($0)}')
DOMAINS=$(echo "${DOMAINS}" | awk '{print tolower($0)}')
TOKEN=$(echo "${TOKEN}" | awk '{print tolower($0)}')

if [ -z "$DOMAINS" ]; then
	echo "DOMAINS missing"
	exit 1
fi

if [ -z "${TOKEN}" ]; then
	echo "TOKEN missing"
	exit 1
fi

if [ "${USE_IPV4}" != "true" ] && [ "${USE_IPV6}" != "true" ]; then
	echo "At least one of USE_IPV4 and USE_IPV6 must be set to 'true'"
	exit 1
fi

while true; do
	echo "Starting loop..."

	# Build base URL
	URL="https://www.duckdns.org/update?domains=${DOMAINS}&token=${TOKEN}"

	# IPv4
	if [ "${USE_IPV4}" = "true" ]; then
		IPV4=$(curl -s -4 ifconfig.io)
		echo "IPv4: ${IPV4}"
		URL="${URL}&ip=${IPV4}"
	fi

	# IPv6
	if [ "${USE_IPV6}" = "true" ]; then
		IPV6=$(curl -s -6 ifconfig.io)
		echo "IPv6: ${IPV6}"
		URL="${URL}&ipv6=${IPV6}"
	fi
	
	# Call URL to update DDNS
	echo "Calling URL: ${URL}"
	RESPONSE=$(curl -s -k "${URL}" & wait)
	echo "Duck DNS response: ${RESPONSE}"

	# Sleep and loop
	sleep $INTERVAL & wait
done
