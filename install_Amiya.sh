    #!/bin/bash

    # =================================================
    #	Description: Amiya-Bot-OneKey
    #	Version: 1.1.0
    #	Author: RHWong
    # =================================================

    Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
    Info="${Green_font_prefix}[信息]${Font_color_suffix}"
    Error="${Red_font_prefix}[错误]${Font_color_suffix}"
    Warrning="${Red_font_prefix}[警告]${Font_color_suffix}"
    Tip="${Green_font_prefix}[提示]${Font_color_suffix}"
    ret_code=`curl -o /dev/null --connect-timeout 3 -s -w %{http_code} https://google.com`
    conda_path=$HOME/miniconda3
    # 如果ret_code变量值是200或者301
    if [ $ret_code -eq 200 ] || [ $ret_code -eq 301 ]; then
        miniconda_url=https://repo.anaconda.com/miniconda
    else
        miniconda_url=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda
    fi
            



    function waiting()
    {
        i=0
        while [ $i -le 100 ]
        do
        for j in '\\' '|' '/' '-'
        do
        printf "\t%c%c%c%c%c ${Info} 兔兔祈祷中... %c%c%c%c%c\r" \
        "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j" "$j"
        sleep 0.1
        done
        let i=i+4
        done
    }

    # 检测本机是否为Centos
    check_sys(){
        if [[ -f /etc/redhat-release ]]; then
            release="Centos"
        elif cat /etc/issue | grep -q -E -i "Debian"; then
            release="Debian"
        elif cat /etc/issue | grep -q -E -i "Ubuntu"; then
            release="Ubuntu"
        elif cat /etc/issue | grep -q -E -i "Centos|red hat|redhat"; then
            release="Centos"
        elif cat /proc/version | grep -q -E -i "Debian"; then
            release="Debian"
        elif cat /proc/version | grep -q -E -i "Ubuntu"; then
            release="Ubuntu"
        elif cat /proc/version | grep -q -E -i "Centos|red hat|redhat"; then
            release="Centos"
        # 如果是未知系统版本则输出unknown
        else
            release="unknown"
        fi
        bit=`uname -m`
    }

    # 如果是Centos则返回警告
    anti_Centos(){
        if [[ ${release} != "Centos" ]]; then
            echo -e "${Info} 检测到当前发行版系统为 ${Green_font_prefix}[${release}]${Font_color_suffix}..."
        else
            echo -e "${Warrning} Amiya官方不推荐使用${Red_font_prefix}[${release}]${Font_color_suffix}进行部署，推荐您使用Docker部署!"
            echo -e "${Warrning} 本脚本可以运行在${Red_font_prefix}[${release}]${Font_color_suffix}上，但未经验证，可能会出现未知错误。"
            # 继续运行请按Y
                read -p "是否继续运行？[Y/n]:" yn
                if [[ $yn == [Yy] ]]; then
                echo -e "${Info} 继续运行..."
                else
                exit 1
                fi
        fi

    }

    # 如果不是x86_64则返回警告
    anti_bit(){
        if [[ ${bit} == "x86_64" ]]; then
            echo -e "${Info} 系统类型为 ${Green_font_prefix}[${bit}]${Font_color_suffix}，开始安装..."
        else
            echo -e "${Warrning} Amiya官方不推荐使用${Red_font_prefix}[${bit}]${Font_color_suffix}进行部署!"
            echo -e "${Warrning} 本脚本可以运行在${Red_font_prefix}[${bit}]${Font_color_suffix}上，但未经验证，可能会出现未知错误。"
            # 继续运行请按Y
                read -p "是否继续运行？[Y/n]:" yn
                if [[ $yn == [Yy] ]]; then
                echo -e "${Info} 继续运行..."
                else
                exit 1
                fi
        fi

    }

    # 判断${release}使用不同方式安装wget和git
    install_wget_git(){
        if [[ ${release} == "Centos" ]]; then
            yum install -y wget git
        elif [[ ${release} == "Ubuntu" ]]; then
            sudo apt update
            sudo apt install -y wget git
        elif [[ ${release} == "Debian" ]]; then
            apt update
            apt install -y wget git
        elif [[ ${release} == "unknown" ]]; then
            echo -e "${Error} 未知系统版本，若无法继续运行请自行安装wget和git"
            sleep 3
        fi
    }

    # 打印release和bit
        # 如果是Centos则返回警告
    print_release_bit(){
        if [[ ${release} != "Centos" ]]; then
            echo -e "${Info} 当前系统为 ${Green_font_prefix}[${release}]${Font_color_suffix} ${Green_font_prefix}[${bit}]${Font_color_suffix}"
        else
            echo -e "${Info} 当前系统为 ${Green_font_prefix}[${release}]${Font_color_suffix} ${Green_font_prefix}[${bit}]${Font_color_suffix}"
            echo -e "${Warrning} Amiya官方不推荐使用${Red_font_prefix}[${release}]${Font_color_suffix}进行部署，推荐您使用Docker部署!"
            echo -e "${Warrning} 本脚本可以运行在${Red_font_prefix}[${release}]${Font_color_suffix}上，但未经验证，可能会出现未知错误。"
            sleep 5
        fi

    }

    # 静默安装conda
    silent_install_conda(){
        # conda命令可用，跳过安装
        if [ -x "$(command -v conda)" ]; then
            echo -e "${Info} 检测到已存在conda，跳过安装"
            sleep 2
        else
            echo -e "${Info} 检测到未安装conda，开始安装"
            # 删除conda目录
            if [ -d "$conda_path" ]; then
                echo -e "${Info} 检测到已存在conda目录，正在删除..."
                rm -rf $conda_path
            fi
            echo -e "${Warrning} 注意，安装中如果提示需要你点击enter键或输入yes，请按照屏幕上的提示输入！"
            echo -e "${Warrning} 安装conda完毕后，请重新连接终端并切换到amiya环境后重新运行此脚本。"
            sleep 4
        # conda安装
            # 下载安装包
                if [[ ${bit} == "x86_64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
                elif [[ ${bit} == "aarch64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
                elif [[ ${bit} == "armv7l" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-armv7l.sh -O miniconda.sh
                elif [[ ${bit} == "i686" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                elif [[ ${bit} == "ppc64le" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-ppc64le.sh -O miniconda.sh
                elif [[ ${bit} == "s390x" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-s390x.sh -O miniconda.sh
                elif [[ ${bit} == "i386" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                else
                    echo -e "${Error} 本脚本不支持${Red_font_prefix}[${bit}]${Font_color_suffix}系统！"
                    exit 1
                fi
            bash miniconda.sh -b
            echo -e "${Info} conda安装结束！"
            sleep 2
        add_conda_path
        source /etc/profile
        check_conda_install
        fi
    }


    # 安装conda
    check_conda(){
        # conda命令可用，跳过安装
        if [ -x "$(command -v conda)" ]; then
            echo -e "${Info} 检测到已存在conda，跳过安装"
            sleep 2
        else
            echo -e "${Info} 检测到未安装conda，开始安装"
            # 删除conda目录
            if [ -d "$conda_path" ]; then
                echo -e "${Info} 检测到已存在conda目录，正在删除..."
                rm -rf $conda_path
            fi
            echo -e "${Warrning} 注意，安装中如果提示需要你点击enter键或输入yes，请按照屏幕上的提示输入！"
            echo -e "${Warrning} 安装conda完毕后，请重新连接终端并切换到amiya环境后重新运行此脚本。"
            sleep 2
            # 按下enter继续
            read -p "确认阅读上述说明后，按下enter键继续..."
        # conda安装
            # 下载安装包
                if [[ ${bit} == "x86_64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
                elif [[ ${bit} == "aarch64" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
                elif [[ ${bit} == "armv7l" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-armv7l.sh -O miniconda.sh
                elif [[ ${bit} == "i686" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                elif [[ ${bit} == "ppc64le" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-ppc64le.sh -O miniconda.sh
                elif [[ ${bit} == "s390x" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-s390x.sh -O miniconda.sh
                elif [[ ${bit} == "i386" ]]; then
                    wget ${miniconda_url}/Miniconda3-latest-Linux-x86.sh -O miniconda.sh
                else
                    echo -e "${Error} 本脚本不支持${Red_font_prefix}[${bit}]${Font_color_suffix}系统！"
                    exit 1
                fi
            bash miniconda.sh -b
            echo -e "${Info} conda安装结束！"
            sleep 2
        add_conda_path
        source /etc/profile
        check_conda_install
        fi
    }

    # 检测conda安装是否成功
    check_conda_install(){
        if [ -x "$(command -v conda)" ]; then
            echo -e "${Info} conda安装成功！"
            sleep 2
        else
            echo -e "${Error} conda安装失败，请手动安装conda"
            exit 1
        fi
    }

    # 将conda加入环境变量
    add_conda_path(){
        echo -e "${Tip} 正在将conda加入环境变量..."
        echo "export PATH=$conda_path/bin:$PATH" >> /etc/profile
        source /etc/profile
        echo -e "${Info} conda加入环境变量完成！"
    }

    create_conda_env(){
        # 判断Amiya环境是否已经存在
        if [ -d "$conda_path/envs/Amiya" ]; then
            echo -e "${Info} Amiya环境已存在，跳过部署！"
            sleep 2
        else
            echo -e "${Info} Amiya环境不存在，开始部署..."
            sleep 2
            conda init bash
            echo y | conda create -n Amiya python=3.8
            conda activate Amiya
            echo -e "${Info} Amiya环境部署完成！请${Red_font_prefix}重新连接${Font_color_suffix}到终端，使用${Green_font_prefix}conda activate Amiya${Font_color_suffix}指令来激活Amiya环境，然后${Red_font_prefix}重新运行${Font_color_suffix}此脚本。"
            exit 1
        fi
    }

    # 检测本地python版本
    check_python()
    {
        local python_version=`python3 -V 2>&1 | awk '{print $2}'`
        # 如果版本大于3.7，小于3.8
        if [ "$python_version" \> "3.7.0" ] && [ "$python_version" \< "3.8.99" ]; then
            echo -e "${Info} 本地python版本为$python_version，符合要求！"
            sleep 2
        else
        # 如果版本小于3.7，大于3.9
            if [ "$python_version" \< "3.6.99" ]; then
                echo -e "${Error} 本地python版本为$python_version，版本过低不符合要求！"
                echo -e "${Tip} 请手动安装python3.7或python3.8，或重新运行脚本安装conda"
                exit 1
        # 如果版本大于3.9
            elif [ "$python_version" \> "3.9.0" ]; then
                echo -e "${Warrning} 本地python版本为$python_version，大于3.8可能会出现依赖版本不支持的情况！"
                # 询问是否继续，输入y继续，输入n退出
                read -p "是否继续？[y/n]:" yn
                if [[ $yn == [Yy] ]]; then
                echo -e "${Info} 继续运行..."
                else
                echo -e "${Info} 退出运行！"
                exit 1
                fi
            else
            # 没有python
                echo -e "${Error} 本地没有安装python！"
                echo -e "${Tip} 请先手动安装python3.7或python3.8，或重新运行脚本使用conda安装"
                exit 1
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
            sleep 2
        else
            echo -e "${Error} pip未安装！"
            # 尝试安装pip 
            echo -e "${Tip} 正在尝试安装pip..."
            sleep 2
                # 尝试安装python
                echo -e "${Tip} 正在尝试使用yum安装pip3..."
                if [[ ${release} == "Centos" ]]; then
                    yum install -y python3-pip
                elif [[ ${release} == "Ubuntu" ]]; then
                    sudo apt install -y python3-pip
                elif [[ ${release} == "Debian" ]]; then
                    apt install -y python3-pip
                elif [[ ${release} == "unknown" ]]; then
                    echo -e "${Error} 未知系统版本，请自行安装pip3！"
                    sleep 3
                    exit 1
                fi
                echo -e "${Info} pip3安装结束！"
                sleep 2

            if [ -x "$(command -v pip3)" ]; then
                echo -e "${Info} pip安装成功！"
                sleep 2
            else
                echo -e "${Error} pip安装失败，请自行安装！"
                exit 1
            fi
        fi
    }

    # 安装兔兔
    install_Amiya()
    {
        cd $HOME
        # 判断Amiya-Bot目录下amiya.py是否存在  
    if [ ! -f "Amiya-Bot/amiya.py" ]; then
        echo -e "${Info} Amiya-Bot主文件不存在，开始安装..."
        sleep 2
        # 如果ret_code变量值是200
        if [ $ret_code -eq 200 ] || [ $ret_code -eq 301 ]; then
            echo -e "${Info} 网络连接正常，开始下载Amiya-Bot..."
            git clone https://github.com/AmiyaBot/Amiya-Bot.git & waiting
        else 
        # 如果ret_code变量值不是200，使用镜像下载
            echo -e "${Info} 网络连接异常，开始使用镜像下载Amiya-Bot..."
            git clone https://ghproxy.com/https://github.com/AmiyaBot/Amiya-Bot.git & waiting
        fi
        echo -e "${Tip} Amiya-Bot下载完成！"
        sleep 2
    else
        echo -e "${Info} Amiya-Bot文件已存在，无需安装！"
        sleep 2
        # 更新Amiya-Bot
        echo -e "${Tip} 正在更新Amiya-Bot..."
        sleep 2
        git pull & waiting
        echo -e "${Tip} Amiya-Bot更新完成！"
        sleep 2
    fi
    }

    # 安装或修复依赖
    install_dependence()
    {
        echo -e "${Info} 开始安装或修复依赖..."
        sleep 2
        cd $HOME/Amiya-Bot
        if [ $ret_code -eq 200 ] || [ $ret_code -eq 301 ]; then
            echo -e "${Info} 网络连通性良好，使用默认镜像下载"
            pip3 install --upgrade pip
            pip install pyyaml~=6.0 --ignore-installed
            pip3 install --upgrade pip -r requirements.txt
        else
            echo -e "${Info} 网络连通性不佳，使用腾讯镜像下载"
            pip3 install --upgrade pip -i https://mirrors.cloud.tencent.com/pypi/simple/
            pip install pyyaml~=6.0 --ignore-installed -i https://mirrors.cloud.tencent.com/pypi/simple
            pip3 install --upgrade pip -r requirements.txt -i https://mirrors.cloud.tencent.com/pypi/simple
        fi
        echo -e "${Tip} 依赖安装或修复完成！"
        sleep 2
    }

    StartAmiya()
    {
    # 启动Amiya
        echo -e "${Tip} 开始安装Amiya-Bot..." 
        check_sys
        anti_Centos
        anti_bit
        select_install
    }

    # 本地安装  
    install_local(){
        install_wget_git
        check_python
        check_pip
        install_Amiya
        chmod -R 766 $HOME/Amiya-Bot
        cd $HOME/Amiya-Bot
        install_dependence
        echo -e "${Tip} Amiya-Bot安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        python3 amiya.py
        # 打印安装位置
        echo -e "${Tip} Amiya-Bot安装位置：$HOME/Amiya-Bot"
        # 打印Amiya启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $HOME/Amiya-Bot && python3 amiya.py${Font_color_suffix}"
    }

    # conda安装
    install_conda(){
        install_wget_git
        check_conda
        create_conda_env
        echo -e "${Tip} 正在安装Amiya-Bot..."
        sleep 2
        install_Amiya
        chmod -R 766 $HOME/Amiya-Bot
        cd $HOME/Amiya-Bot
        install_dependence
        echo -e "${Tip} Amiya-Bot安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        python3 amiya.py
        # 打印安装位置
        echo -e "${Tip} Amiya-Bot安装位置：$HOME/Amiya-Bot"
    #    打印Amiya启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $HOME/Amiya-Bot && conda activate Amiya && python3 amiya.py${Font_color_suffix}"
    }

    # 静默conda安装
    silent_start(){
        check_sys
        print_release_bit
        install_wget_git
        silent_install_conda
        create_conda_env
        echo -e "${Tip} 正在安装Amiya-Bot..."
        sleep 2
        install_Amiya
        chmod -R 766 $HOME/Amiya-Bot
        cd $HOME/Amiya-Bot
        install_dependence
        echo -e "${Tip} Amiya-Bot安装完成！"
        sleep 2
        echo -e "${Tip} 开始尝试运行，如有问题请提交issue"
        python3 amiya.py
        # 打印安装位置
        echo -e "${Tip} Amiya-Bot安装位置：$HOME/Amiya-Bot"
    #    打印Amiya启动指令
        echo -e "启动指令如下："
        echo -e "${Green_font_prefix}cd $HOME/Amiya-Bot && conda activate Amiya && python3 amiya.py${Font_color_suffix}"
    }


    # 提示选择在本地安装还是在conda安装
    select_install(){
        echo -e "${Info} 请选择安装方式"
        echo -e "1. conda虚拟环境安装(推荐)"
        echo -e "2. 本地安装"
        read -p "请输入数字:" num
        case "$num" in
            1)
            install_conda
            ;;
            2)
            install_local
            ;;
            *)
            echo -e "${Error} 请输入正确的数字"
            exit 1
            ;;
        esac
    }



# 判断脚本运行时是否包含-s参数，如果有则跳过确认步骤
    if [[ $1 == "-s" ]]; then
        silent_start
    else
        StartAmiya
    fi
