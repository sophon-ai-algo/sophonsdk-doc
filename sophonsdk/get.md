# 1.3 获取SDK

SophonSDK开发包由两部分组成：

* **基于x86的Ubuntu开发Docker：**我们提供统一的Docker基础开发镜像以规避环境不一致带来的隐性问题，特别是对于初级用户，强烈建议使用我们提供的Docker镜像作为开发环境进行模型转换和算法迁移工作。从3.y.z开始，Docker开发镜像由2.y.z时的Ubuntu16.04升级为Ubuntu18.04。
* **SophonSDK：**sophonsdk\_v\<x.y.z>.tar.gz，其中x.y.z为版本号。SophonSDK将以目录映射的方式挂载到Docker容器内部供用户使用。SDK分windows版本和Linux版本。Windows版本的SDK的使用方式请参见SDK包下的用户文档。本文档后续内容均以Linux下的使用操作为例。

{% hint style="warning" %}
在基于x86的Ubuntu/CentOS/Windows 10开发环境下，您均可以使用基于Ubuntu的Docker来搭建开发环境。

需要注意的是：在windows下，您只能使用基于Ubuntu的Docker来搭建编译模型的开发环境，若要在windows下使用设备进行推理，您需要使用Windows版SDK。

**若您使用其他非x86架构的主机及国产操作系统**，模型转换部分您仍然需要使用一台x86的主机来完成，但是您可以**直接在宿主机使用SDK配置运行环境**。若遇到问题，请联系技术支持获取帮助。
{% endhint %}

您可以访问[算能官网](https://developer.sophgo.com/site/index/material/all/all.html)来下载相关资料。SophonSDK 3需要Ubuntu 18.04，请确保主机系统满足要求或使用我们的提供的开发镜像来配置环境。

|                项目               |                                    下载页面                                    |
| :-----------------------------: | :------------------------------------------------------------------------: |
| Ubuntu18.04开发Docker - Python3.7 | [点击前往官网下载页面](https://developer.sophgo.com/site/index/material/11/all.html) |
|       SophonSDK3.0.0  开发包       | [点击前往官网下载页面](https://developer.sophgo.com/site/index/material/17/all.html) |

