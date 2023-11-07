if [ $(id -u) -ne 0 ]; then
  echo "请以超级用户身份运行此脚本" >&2
  exit 1
fi


# 删除用户
for i in `seq -w 0 09`
do
        userdel user_${i}
        echo  "user_${i}deleted"

	# 检查用户是否删除成功
	if [ $? -eq 0 ]; then
  		echo "用户 user_${i} 已被删除"
	else
  		echo "无法删除用户 user_${i}"
  		exit 1
	fi

done
