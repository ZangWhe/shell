# 一键部署服务的脚本

#------------------------------------

#!/bin/bash

# 检测上一步是否执行成功
check_prestep_ok()
{
	if [ $? -ne 0 ]
	then
		echo "$1 error."
		exit 1
	fi
}


# 下载nginx
download_nginx()
{
	cd /usr/local/src
	if [ -f nginx-1.23.0.tar.gz ]
	then
		echo "当前目录已经存在nginx-1.23.0.tar.gz"
		echo "检测md5"
		nginx_md5=`md5sum nginx-1.23.0.tar.gz | awk '{print $1}'`
		# 已经存在的文件的md5值，这里随便写的
		if [ ${nginx_md5} == 'e123123124151531241234123' ]
		then
			return 0
		else
			sudo /bin/mv nginx-1.23.0.tar.gz nginx-1.23.0.tar.gz.old
		fi
	fi

	sudo curl -O http://nginx.org/download/nginx-1.23.0.tar.gz
	check_prestep_ok "下载Nginx"
}

# 安装nginx
install_nginx()
{
	cd /usr/local/src
	echo "解压Nginx"
	sudo tar zxf nginx-1.23.0.tar.gz
	check_prestep_ok "解压Nginx"
	cd nginx-1.23.0
	
	# yum版本安装依赖
	echo "安装依赖"
	if which yum >/dev/null 2>&1
	then
		# REHL/Rocky
		# 遍历依赖包
		for pkg in gcc make pcre-devel zlib-devel openssl-devel
		do
			# 如果不存在就安装
			if ! rpm -q $pkg >/dev/null 2>&1
			then
				sudo yum install -y $pkg
				check_prestep_ok "yum 安装$pkg"
			else
				echo "$pkg已安装"
			fi
		done
	fi
	
	# apt版本安装依赖
	if which apt >/dev/null 2>&1
        then
		# ubuntu
                # 遍历依赖包
                for pkg in make libpcre++-dev libssl-dev zlib1g-dev
                do
                        # 如果不存在就安装
                        if ! rpm -q $pkg >/dev/null 2>&1
                        then
                                sudo apt install -y $pkg
                                check_prestep_ok "apt 安装$pkg"
                        else
                                echo "$pkg已安装"
                        fi
                done
        fi

	echo "配置Nginx"
	sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module
	check_prestep_ok "配置Nginx"

	echo "编译安装"
	sudo make && sudo make install
	check_prestep_ok "编译和安装"

	echo "编辑systemd服务管理脚本"
	check_prestep_ok "编辑服务管理脚本"

	echo "加载服务"
	sudo systemctl unmaskk nginx.service
	sudo systemctl daemon-reload
	sudo systemctl enable nginx
	echo "启动Nginx"
	sudo systemctl start nginx
	check_prestep_pk "启动Nginx"

}

download_nginx

