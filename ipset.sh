#!/bin/bash

curl -s https://api.antizapret.info/all.php > /tmp/antizapret.dump

ipset create ROSKOMNADZOR_BANNED hash:net maxelem 134217728 hashsize 65536 2>/dev/null

declare -A IS_BANNED

function isValidAddress() {
	ADDR="$1"; shift
	case "$ADDR" in
		192.168.*)
			return 1
			;;
		172.1[6-9].*)
			return 1
			;;
		172.2[0-9].*)
			return 1
			;;
		172.3[0-1].*)
			return 1
			;;
		10.*)
			return 1
			;;
		127.*)
			return 1
			;;
	esac
	return 0
}

for ADDR in $(grep -Eo '[0-9][0-9]*\.[0-9]*\.[0-9]*\.[0-9]*([/][0-9]*)?' /tmp/antizapret.dump); do
	if ! isValidAddress "$ADDR"; then
		continue
	fi
	ipset add ROSKOMNADZOR_BANNED "$ADDR"
	IS_BANNED[$ADDR]=1
done

for ADDR in $(ipset list ROSKOMNADZOR_BANNED | grep -Eo '[0-9][0-9]*\.[0-9]*\.[0-9]*\.[0-9]*([/][0-9]*)?'); do
	if [ "${IS_BANNED[$ADDR]}" = '1' ]; then
		continue
	fi
	ipset del ROSKOMNADZOR_BANNED "$ADDR"
done

