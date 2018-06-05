```
iptables -t mangle -A -m set --match-set ROSKOMNADZOR_BANNED dst -j MARK --set-mark 0x1
echo 128 rknban >> /etc/iproute2/rt_tables
ip rule add from all fwmark 0x1 lookup rknban
```
