# 1.5.2 环境配置-Windows

### 1.5.2.1 开发环境配置

Windows下的开发环境仅支持模型转换，具体操作方式可参考《Windows Docker安装与SDK使用指南.pdf》。

{% file src="../../.gitbook/assets/Windows Docker安装与SDK使用指南.pdf" %}

{% hint style="danger" %}
**注意：**由于BMNNSDK内的文件均为linux系统下文件，因此您需要在WSL2系统中解压文件，直接在windows下解压可能导致文件损坏。
{% endhint %}

{% hint style="info" %}
当然，您也可以使用VMWare等虚拟机软件在windows下获得Ubuntu系统环境，从而加载使用我们提供的开发镜像。
{% endhint %}

### **1.5.2.2 运行环境配置**

若您不仅需要在windows下执行模型转换还需要在windows下执行模型推理，则您还需要联系我们获取windows下专用的附加开发包：包括硬件驱动、运行时库等。附加开发包暂未提供在线下载链接，请联系我们的技术支持获取。
