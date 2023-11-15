
# 使用传参的方法写一个脚本，实现加减乘除的功能

# 例如 sh a.sh 1 2,分别计算加减乘除的结果

# 要求：
## 1)脚本需判断提供的两个数字是否必须为证书
## 2)在做减法或者除法时，要判断哪个数字大
## 3)减法时要用大的数字减去小的
## 4)除法时徐奥用大的数字除以小的数字，并且结果需要保留两个小数点


# --------------------------------------------------------------------
#!/bin/bash

# 先判断参数数量是不是2
if [ $# -ne 2 ]
then
	echo "The number of parameter is not 2,Please usage like: ./$0 1 2"
	exit 1
fi

# 判断提供的数字是否是正整数的函数
is_int()
{
	if echo "$1"|grep -q '[^0-9]'
	then
		echo "$1 is not integer numver."
		exit
	fi
}

# 找大的数
max()
{
	if [ $1 -ge $2 ]
	then
		echo $1
	else
		echo $2
	fi
}
# 找小的数
min()
{
	if [ $1 -lt $2 ]
	then
		echo $1
	else
		echo $2
	fi
}
# 加法
sum()
{
	echo "$1 + $2 = $[ $1+$2 ]"
}

# 减法
minus()
{
	big=`max $1 $2`
	small=`min $1 $2`
	echo "$big - $small = $[ $big-$small ]"
}

# 乘法
mult()
{
	
	echo "$1 * $2 = $[ $1*$2 ]"
}

# 除法
div()
{
	big=`max $1 $2`
	small=`min $1 $2`
	d=`echo "scale=2;$big/$small"|bc`
	echo "$big / $small = $d"
}


is_int $1
is_int $2
sum $1 $2
minus $1 $2
mult $1 $2
div $1 $2
