# 有两个文件a.txt和b.txt
# 需求是将a,txt有的但b.txt中没有的行找出来，并写入到c.txt中
# 然后计算c.txt的行数

#-----------------------------------------------------------------------

#!/bin/bash

# 如果c.txt存在就删掉
[ -f c.txt ] && rm -f c.txt

# 使用while循环遍历a.txt的所有行
cat a.txt | while read line
do
	# 如果b.txt中没有这行内容，就写入c.txt
	# "^${line}$"是一个正则表达式，^表示行的开始，$表示行的结束，${line}是要匹配的行内容。
	# 这确保只匹配整行内容和${line}完全相同的行
	if ! grep -q "^${line}$" b.txt
	then
		echo ${line} >> c.txt
	fi
done

# 统计c.txt的行数
wc -l c.txt
