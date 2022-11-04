<div align="center">

# Amiya-Bot-OneKey

用于部署 [AmiyaBot](https://github.com/AmiyaBot/Amiya-Bot) 框架的 QQ 聊天机器人的Linux快速部署脚本<br>

注意：本项目仅用于快速部署 [AmiyaBot](https://github.com/AmiyaBot/Amiya-Bot) 本体，后续对接何种前端(如[Go-cqhtp](https://github.com/Mrs4s/go-cqhttp/))取决您自己的选择，这些部分并不包含在部署范围内，请参考[官方教程](https://www.amiyabot.com/guide/deploy/console/configure.html)。

注意：本脚本仅通过 Ubuntu x86_64 验证，其他发行版及类型系统如果出现问题请提交issue！

</div>
<!-- projectInfo end -->

## 快速启动

### 安装

```shell
wget -N https://github.com/rhwong/Amiya-Bot-OneKey/raw/main/install_Amiya.sh && chmod -R 755 install_Amiya.sh
./install_Amiya.sh
```
#### 【注意事项】

1.在Conda安装时需要键入一些确认指令，当屏幕上提示按 `Enter` 时请按下，当提示是否确认时，请输入 `yes` 。许可部分可以按 `Q` 跳过阅读。

请不要自行修改安装步骤中的安装位置，直接按下 `Enter` 安装到默认位置即可。

2.由于conda在加入环境变量后，脚本会退出运行。此时必须重新连接到终端以生效，此时请务必断开ssh，重新连接终端。

重新连接后提示符前面出现 `(base)` ，例如 `(base) root@ecs:~# ` 这样的显示就是conda成功安装了。

在成功安装conda之后，我们需要重新运行一次脚本：

键入 `conda activate Amiya` 以激活Amiya环境，然后键入 `./install_Amiya.sh` 重新运行脚本以继续安装。

### 启动

依次输入如下指令来启动Amiya-Bot，此后也如此。

```shell
conda activate Amiya
cd $HOME/Amiya-Bot
python3 amiya.py
```

### 更新和修复

重复安装步骤，按照原本的安装方式选择即可。检测到已存在Amiya-Bot目录时，脚本会自动拉取代码并更新依赖。