# 1.4 获取BMNNSDK2 SDK

BMNNSDK2开发包由两部分组成：

* **基于x86的Ubuntu16.04开发Docker：**bmnnsdk2-bm1684-ubuntu.docker。我们提供统一的Docker基础开发镜像以规避环境不一致带来的隐性问题，特别是对于初级用户，我们强烈建议使用我们提供的Docker镜像作为开发环境进行模型转换和算法迁移工作。
* **BMNNSDK：**bmnnsdk2-bm1684\_vx.x.x.tar.gz，其中x.x.x为版本号。BMNNSDK将以目录映射的方式挂载到Docker容器内部供用户使用。SDK分windows版本和Linux版本。

{% hint style="warning" %}
本节后续操作均为基于x86的Ubuntu/CentOS/Windows 10开发环境，**若您使用其他架构或操作系统**，请**直接在宿主机进行相应操作**，而不要使用我们提供的docker镜像。遇到问题，请联系技术支持获取帮助。
{% endhint %}

您可以访问[算能官网](https://sophon.cn/drive/index.html)来下载相关资料。

|                                 |                                               |
| ------------------------------- | --------------------------------------------- |
| Ubuntu16.04开发Docker - Python3.5 | [点击前往官网下载页面](https://sophon.cn/drive/44.html) |
| Ubuntu16.04开发Docker - Python3.7 | [点击前往官网下载页面](https://sophon.cn/drive/44.html) |
| BMNNSDK2.7.0  开发包               | [点击前往官网下载页面](https://sophon.cn/drive/45.html) |
| BMNNSDK2.6.0  开发包               | [点击前往官网下载页面](https://sophon.cn/drive/45.html) |
| BMNNSDK2.5.0  开发包               | [点击前往官网下载页面](https://sophon.cn/drive/45.html) |

我们也提供其他OS版本的基础开发Docker镜像（如Ubuntu18.04），以及Soc模式下的基础运行Docker镜像（基于Debian 9），您可以联系我们的技术支持获取。

各类Docker镜像的构建文件Dockerfile参见github仓库[docker-images](https://github.com/sophon-ai-algo/docker-images)，更多docker镜像构建文件陆续更新中。

