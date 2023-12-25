# 将某个网段（如192.168.0.0/24）在线的ip列举出来

# ------------------------------------------------------------

#!/bin/bash

for i in `seq 1 254`
do
	# 如果Ping通，则命令执行成功，条件为真
	if ping -c 2 -W 2 192.168.0.$i >/dev/null 2>/dev/null
	then
		echo "192.168.0.$i 是通的"
	else
		echo "192.168.0.$i 是不通的"
	fi
done

