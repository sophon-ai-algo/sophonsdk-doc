# 5.1 概述

目前我们提供如下两种环境下的docker部署的参考示例，您可以在我们提供的基础镜像的基础上，添加自己所需要的软件包，构建自己所需的docker镜像：

* x86下使用了PCIe加速卡的基于Ubuntu16.04/18.04的docker部署：您需要在宿主机上安装好加速卡驱动程序，设备将被映射到容器内部以供程序使用；您需要从SophonSDK中抽取您平台对应的运行库并将其映射到容器内部或拷贝到镜像内部以供程序使用。
* 在SoC模式下基于debian9或Ubuntu20.04的docker部署：驱动已经在设备上集成安装好；您需要将/system目录下的软件包映射到容器内部或者拷贝到镜像内部以供程序使用。

其他操作系统及平台下的docker部署请联系我方技术支持获取进一步的指导。近期我们将把相关docker镜像上传至docker hub以方便用户下载使用，相关dockerfile文件也将放在github仓库[docker-images](https://github.com/sophon-ai-algo/docker-images)开源。