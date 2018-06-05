#!/bin/bash

ipset create ROSKOMNADZOR_BANNED hash:net maxelem 134217728 hashsize 65536

declare -A IS_BANNED

for ADDR in $(grep -Eo '[0-9][0-9]*\.[0-9]*\.[0-9]*\.[0-9]*([/][0-9]*)?' raw-list/dump.csv); do
	ipset add ROSKOMNADZOR_BANNED "$ADDR"
	IS_BANNED[$ADDR]=1
done

for ADDR in $(ipset list ROSKOMNADZOR_BANNED | grep -Eo '[0-9][0-9]*\.[0-9]*\.[0-9]*\.[0-9]*([/][0-9]*)?'); do
	if [ "${IS_BANNED[$ADDR]}" = '1' ]; then
		continue
	fi
	ipset del ROSKOMNADZOR_BANNED "$ADDR"
done

