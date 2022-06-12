# 1.5.3 环境配置-SoC

### 1.5.3.1 开发环境配置

对于SoC模式，模型转换也需要在docker开发容器中完成；C/C++程序也建议在docker开发容器中使用交叉编译工具链编译生成可执行文件后，再拷贝到Soc目标平台运行。docker开发容器的配置参照前述章节相关内容。

若您希望直接在SoC中进行C/C++程序的编译，请从SDK中拷贝编译所需的头文件至SoC平台中，并在makefile或CMakeList中设置好相应的路径。

### 1.5.3.2 关闭默认算法服务

SE5盒子默认预置了人脸抓拍识别的应用，若您想关闭预置的算法应用，请先ssh登录到盒子终端，再执行命令关闭：

```
# ssh登录盒子终端，默认用户名和密码均为linaro
ssh linaro@<SE5_IP>
```

```
#  盒子终端内部
cd /bm_bin
./bm_switch2box
# 执行后盒子将自动重启
# 若您想启动默认的算法应用，请重新进行SD卡刷机。
```

{% hint style="info" %}
注意：SE5盒子自带的操作系统并没有桌面系统；只有预置了人脸抓拍识别应用的盒子才带有webUI界面，HDMI接口有信号输出；官网提供的卡刷包为干净系统的卡刷包，不带人脸抓拍识别应用，HDMI接口无信号输出，不带webUI界面。若您想使用预置了人脸抓拍应用的固件，请联系我们的技术支持获取。
{% endhint %}

### 1.5.3.3 运行环境配置

对于SoC平台，内部已经集成了相应的SDK运行库包，位于/system目录下，只需设置环境变量即可。

```bash
# 设置环境变量
export PATH=$PATH:/system/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/system/lib/:/system/usr/lib/aarch64-linux-gnu
export PYTHONPATH=$PYTHONPATH:/system/lib
```
