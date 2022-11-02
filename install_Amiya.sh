#!/bin/bash

# =================================================
#	Description: Amiya-Bot-OneKey
#	Version: 1.0.0
#	Author: RHWong
# =================================================

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[提示]${Font_color_suffix}"
ret_code=`curl -o /dev/null --connect-timeout 3 -s -w %{http_code} https://github.com`

# 检测本地python版本
check_python()
{
    local python_version=`python3 -V 2>&1 | awk '{print $2}'`
    # 如果版本大于3.7，小于3.8
    if [ "$python_version" \> "3.7.0" ] && [ "$python_version" \< "3.8.99" ]; then
        echo -e "${Info} 本地python版本为$python_version，符合要求！"
    else
    # 如果版本小于3.7，大于3.9
        if [ "$python_version" \< "3.6.99" ] || [ "$python_version" \> "3.9.0" ]; then
            echo -e "${Error} 本地python版本为$python_version，不符合要求！"
            echo -e "${Tip} 请安装python3.7或python3.8！"
        else
            # 尝试安装python

            # 判断系统是否为Ubuntu
             if [ -x "$(command -v apt)" ]; then
                echo -e "${Tip} 正在尝试安装python3.8..."
                apt install -y python3.8
            else
            # 使用yum安装python3.8
                echo -e "${Tip} 正在尝试使用yum安装python3.8..."
                yum install -y python3.8
            fi
            echo -e "${Info} python3.8安装完成！"
            
        fi

    fi
}

# 检测是否安装pip
check_pip()
{
    if [ -x "$(command -v pip3)" ]; then
        # 升级pip
         python3 -m pip install --upgrade pip
         echo -e "${Info} pip已更新！"
    else
        echo -e "${Error} pip未安装！"
        # 尝试安装pip 
        echo -e "${Tip} 正在尝试安装pip..."
            # 判断系统是否为Ubuntu
             if [ -x "$(command -v apt)" ]; then
                apt install -y python3-pip
                echo -e "${Info} pip安装完成！"
            else
            # 使用yum安装pip
                yum install -y python3-pip
                echo -e "${Info} pip安装完成！"
            fi

        if [ -x "$(command -v pip3)" ]; then
            echo -e "${Info} pip安装成功！"
        else
            echo -e "${Error} pip安装失败，请自行安装！"
            exit 1
        fi
    fi
}

function waiting()
{
i=0
while [ $i -le 100 ]
do
for j in '\\' '|' '/' '-'
do
printf "\t%c%c%c%c%c ${Info} 少女祈祷中... %c%c%c%c%c\r" \
"$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j"
sleep 0.1
done
let i=i+4
done
}


install_Amiya()
{
    # 判断Amiya-Bot目录下amiya.py是否存在  
if [ ! -f "Amiya-Bot/amiya.py" ]; then
    echo -e "${Info} Amiya-Bot主文件不存在，开始安装..."
    # 如果ret_code变量值是200
    if [ $ret_code -eq 200]; then
        echo -e "${Info} 网络连接正常，开始下载Amiya-Bot..."
        git clone https://github.com/AmiyaBot/Amiya-Bot.git & waiting
    else 
    # 如果ret_code变量值不是200，使用镜像下载
        echo -e "${Info} 网络连接异常，开始使用镜像下载Amiya-Bot..."
        git clone https://ghproxy.com/https://github.com/AmiyaBot/Amiya-Bot.git & waiting
    fi
    echo -e "${Tip} Amiya-Bot下载完成！"
else
    echo -e "${Info} Amiya-Bot文件已存在，无需安装！"
fi
}

# 安装或修复依赖
install_dependence()
{
    echo -e "${Info} 开始安装或修复依赖..."
    pip install pyyaml~=6.0 --ignore-installed
    cd Amiya-Bot
    if [ $ret_code -eq 200 ]; then
        echo -e "${Info} 网络连通性良好，使用默认镜像下载"
        pip3 install --upgrade pip -r requirements.txt
    else
        echo -e "${Info} 网络连通性不佳，使用腾讯镜像下载"
        pip3 install --upgrade pip -r requirements.txt -i https://mirrors.cloud.tencent.com/pypi/simple
    fi
    echo -e "${Tip} 依赖安装或修复完成！"
}

StartAmiya()
{
# 启动Amiya
echo -e "${Tip} 正在启动Amiya-Bot..." 
check_python
check_pip
pip3 install --upgrade pip
install_Amiya
install_dependence
chmod -R 766 /workspace
cd /workspace/Amiya-Bot
python3 amiya.py
}
StartAmiya
