### 遍历data目录下的txt文件
### 将这些文件作个备份
### 并将文件名加上年月日的后缀

### ---

#!/bin/bash

## 定义域、后缀变量
suffix=`date +%Y%m%d`
target_path="data"
save_path="data/copy/"

if [ ! -d ${save_path} ];then
	mkdir ${save_path}
fi


for f in `ls ${target_path}/*.txt`
do
	filename=$(basename "$f" .txt)
	echo "文件名${filename}"
	echo "备份文件${f}"
	echo "日期${suffix}"
	cp ${f} ${save_path}${filename}_${suffix}".txt"
done
