# 写一个脚本，判断给定的一串数字是否是合法的日期

# -------------------------------------------------------------------------

#!/bin/bash

# 判断是否提供一个参数，判断参数的长度是否等于8

if [ $# -ne 1 ] || [ ${#1} -ne 8 ]
then
	echo "Usage: bash $0 yyyymmdd"
	exit 1
fi

mydate=$1
year=${mydate:0:4}
month=${mydate:4:2}
day=${mydate:6:2}

if cal -d $year-$month-$day >/dev/null 2>/dev/null
then
	echo "The date is OK. The date is $year年$month月$day日"
else
	echo "The date is error"
fi
