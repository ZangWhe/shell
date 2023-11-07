# 新建用户并保存用户名和密码到指定文件
#!/bin/bash

targetfile='temp/userinfo.txt'
if [ -f ${targetfile} ]
then
	rm -f ${targetfile}
fi

if ! which mkpasswd
then
	yum install -y expect
fi

for i in `seq -w 0 09`
do
	p=`mkpasswd -l 15 -s 0`
	useradd user_${i} && echo "{p}" | passwd --stdin user_${i}
	echo "user_${i} ${p}" >> ${targetfile}
done
