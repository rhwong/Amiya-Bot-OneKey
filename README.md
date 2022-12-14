<div align="center">

# Amiya-Bot-OneKey

用于部署 [AmiyaBot](https://github.com/AmiyaBot/Amiya-Bot) 框架的 QQ 聊天机器人的Linux快速部署脚本<br>


<img src="https://img.shields.io/github/issues/rhwong/Amiya-Bot-OneKey"> <img src="https://img.shields.io/github/forks/rhwong/Amiya-Bot-OneKey"> 
<img src="https://img.shields.io/github/stars/rhwong/Amiya-Bot-OneKey"> <img src="https://img.shields.io/github/license/rhwong/Amiya-Bot-OneKey">

注意：本项目仅用于快速部署 [AmiyaBot](https://github.com/AmiyaBot/Amiya-Bot) 本体，后续对接何种前端(如[Go-cqhtp](https://github.com/Mrs4s/go-cqhttp/))取决您自己的选择，这些部分并不包含在部署范围内，请参考[官方教程](https://www.amiyabot.com/guide/deploy/console/configure.html)。

注意：本脚本仅在以下发行版经过测试

<img src="https://img.shields.io/badge/Ubuntu-x86__64-red?style=flat-square&logo=ubuntu"> 
<img src="https://img.shields.io/badge/Ubuntu-aarch64-red?style=flat-square&logo=ubuntu"> 
<!--<img src="https://img.shields.io/badge/CentOS-x86__64-green?style=flat-square&logo=centos"> -->
<img src="https://img.shields.io/badge/Debian11-x86__64-purple?style=flat-square&logo=debian">

不支持CentOS和Debian11以下，其原因是AmiyaBot中使用的playwright所支持的Linux发行版只有Ubuntu18/20/22/Debian11，

并且其中Ubuntu18将在2022年12月后停止支持，所以请各位部署时注意选择服务器系统。

如果无法部署，请换用Docker的方式进行部署。


</div>
<!-- projectInfo end -->

## 快速启动

### 安装

```shell
wget -N https://ghproxy.com/https://github.com/rhwong/Amiya-Bot-OneKey/raw/main/install_Amiya.sh && chmod -R 755 install_Amiya.sh && ./install_Amiya.sh
```
也可以这样启动安装脚本 `./install_Amiya.sh -s` 

使用 `-s` 参数可以跳过所有确认步骤使用conda安装方式安装。

### 启动

#### Conda 安装时

```
# 前台运行
cd $HOME/Amiya-Bot && $HOME/miniconda3/envs/Amiya-Bot/bin/python3 amiya.py
# Screen 后台运行
screen -dmS Amiya-Bot cd $HOME/Amiya-Bot && $HOME/miniconda3/envs/Amiya-Bot/bin/python3 amiya.py
```
#### 本地安装时
```
# 前台运行
cd $HOME/Amiya-Bot && python3 amiya.py
# Screen 后台运行
screen -dmS Amiya-Bot cd $HOME/Amiya-Bot && python3 amiya.py
```

没有screen请自行安装，Ubuntu使用 `sudo apt-get -y install screen` CentOS使用`yum -y install screen`。

使用以下命令可以恢复screen窗口

```shell
screen -r Amiya
```

### 安装其他依赖

脚本会自动搜索目录下的所有requirements.txt文件并逐个安装，但如果本项目的插件不是这样设计的，你可以按照底下的示例为miniconda的python环境安装依赖
```
$HOME/miniconda3/envs/Amiya-Bot/bin/pip3 install wordcloud~=1.8.2.2 -i https://mirrors.cloud.tencent.com/pypi/simple/
```

### 更新和修复

重复安装步骤，按照原本的安装方式选择即可。检测到已存在Amiya-Bot目录时，脚本会自动拉取代码并更新依赖。
