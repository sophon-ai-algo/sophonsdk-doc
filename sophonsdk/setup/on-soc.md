# 1.4.3 环境配置-SoC

### 1.5.3.1 开发环境配置

对于SoC模式，模型转换也需要在docker开发容器中完成；C/C++程序也建议在docker开发容器中使用交叉编译工具链编译生成可执行文件后，再拷贝到Soc目标平台运行。docker开发容器的配置参照前述章节相关内容。

若您希望直接在SoC中进行C/C++程序的编译，请从SDK中拷贝编译所需的头文件至SoC平台中，并在makefile或CMakeList中设置好相应的路径。

{% hint style="warning" %}
注意：

1. SE微服务器目前已经不再预置人脸抓拍应用gate，gate应用也将不再维护。后续我们也会将SE微服务器的默认系统升级为Ubuntu 20.04，并自带一个web界面用于查询和配置基础信息；同时使用qt编写了一个简易的界面以方便用户配置IP，您可以连接HDMI接口到显示器查看，并使用键鼠一体的套装进行相应操作。
2. SE微服务器自带的操作系统并没有桌面系统，您需要使用ssh登录到微服务器终端内进行操作开发。
{% endhint %}

### 1.5.3.2 运行环境配置

对于SoC平台，内部已经集成了相应的SDK运行库包，位于/system目录下，只需设置环境变量即可。

```bash
# 设置环境变量
export PATH=$PATH:/system/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/system/lib/:/system/usr/lib/aarch64-linux-gnu
export PYTHONPATH=$PYTHONPATH:/system/lib
```
