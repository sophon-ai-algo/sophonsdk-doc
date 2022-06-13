# 1.2 资料简介

SophonSDK 是一个一站式SDK，其中包含了模型转换、算法移植、int8量化等相关模块，我们提供了包括文档、视频、论坛、开源仓库等一系列资料帮助用户进行算法移植和开发工作，具体如下：

**开发指南：**[**https://sophgo-doc.gitbook.io/sophonsdk3/**](https://sophgo-doc.gitbook.io/sophonsdk3)，其中包括：基本概念及SDK简介；资料简介、文档说明；SDK的获取、安装、配置及更新；快速入门例子、模型转换及模型量化、示例代码的讲解、docker部署等内容。

**网络和算子支持情况：**关于网络和算子的支持情况，请查看《NNToolChain用户开发手册》中的附录 [**DL Ops\&Models支持情况**](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/appendix/nn\_support.html)。也可以通过工具链中转换命令查看。

**FAQ：**[**https://doc.sophgo.com/docs/docs\_latest\_release/faq/html/index.html**](https://doc.sophgo.com/docs/docs\_latest\_release/faq/html/index.html)，其中包括：基础概念、环境配置、设备使用、模型转换及量化、多媒体、程序优化等方面的常见问题及解答。

**官网视频教程：**[**https://developer.sophgo.com/site/index/course/all/all.html**](https://developer.sophgo.com/site/index/course/all/all.html)，其中包括：智算卡、智算盒子、智算服务器等产品介绍视频；快速跑通PCIE模式的例程、快速跑通SoC模式的例程、SDK算法移植介绍、BMCV编程示例、编解码编程示例、BMLang编程示例、BMKernel(OKKernel/TPUKernel)编程示例。

**官网文档中心：**[**https://developer.sophgo.com/site/index/document/all/all.html**](https://developer.sophgo.com/site/index/document/all/all.html)，其中分产品手册和开发手册两大类，开发手册主要包括关于多媒体（视频及图片编解码）、BMLib（硬件基础接口：设备Handle的管理，内存管理、数据搬运、API的发送和同步、A53使能等）、BMCV（图像运算处理库）、SAIL（支持Python/C++的高级易用接口）、NNtoolChain（模型转换）、量化工具、BMLang（基于C++的面向Sophon TPU的高级编程语言，可开发自定义算子）、OKKernel（基于Sophon芯片底层原子操作接口的底层编程接口，可开发并行计算加速程序）等模块的用户开发手册（在线html版 + pdf版本）

**官网下载中心：**[**https://developer.sophgo.com/site/index/material/all/all.html**](https://developer.sophgo.com/site/index/material/all/all.html)，其中有：基础开发docker镜像（[https://developer.sophgo.com/site/index/material/11/all.html](https://developer.sophgo.com/site/index/material/11/all.html)）、SDK（[https://developer.sophgo.com/site/index/material/17/all.html](https://developer.sophgo.com/site/index/material/17/all.html)）、SoC升级及固件程序（[https://developer.sophgo.com/site/index/material/12/all.html](https://developer.sophgo.com/site/index/material/12/all.html)）、K8S Device Plugin & Prometheus Exporter相关（[https://developer.sophon.ai/site/index/material/11/74.html](https://developer.sophon.ai/site/index/material/11/74.html)、[https://developer.sophgo.com/site/index/material/11/75.html](https://developer.sophgo.com/site/index/material/11/75.html)）等文件的下载链接。

**官网论坛：**[https://developer.sophgo.com/forum/view/43.html](https://developer.sophgo.com/forum/view/43.html)（欢迎在官网论坛向我们发起技术支持提问帖）

**云开发平台（SOPHGO TEAM）**：[https://cloud.sophgo.com/developer/platform/index](https://cloud.sophgo.com/developer/platform/index)（提供在线的TPU开发软硬件环境）

**开源仓库：**

* examples样例：[https://github.com/sophon-ai-algo/examples](https://github.com/sophon-ai-algo/examples)：从3.0.0开始，SDK下不再包含examples参考例程，有关编解码、模型转换、模型量化、推理等一系列样例程序请参考github仓库[examples](https://github.com/sophon-ai-algo/examples)。同时，也欢迎各位通过github issues向我们反馈您在使用过程中遇到的问题，并向我们提交PR共同参与examples仓库的建设。
* SE5盒子通过QT使用HDMI接口显示图像：[https://github.com/sophon-ai-algo/sophon-qt](https://github.com/sophon-ai-algo/sophon-qt)
* BSP：[https://gitee.com/sophon-ai/bsp-sdk](https://gitee.com/sophon-ai/bsp-sdk)
* BM-FFmpeg：[https://gitee.com/sophon-ai/bm\_ffmpeg](https://gitee.com/sophon-ai/bm\_ffmpeg)

**请先阅读开发指南，熟悉环境配置及SDK使用。**当您在某个环节遇到问题时，可以根据下面的表格指引，阅读相应的模块文档了解更加详细的信息。这些文档均位于[官网文档中心](https://developer.sophgo.com/site/index/document/all/all.html)，提供在线版和PDF版本，以方便用户查看和下载：

| 文档名称                                                                                              | 说明                                                                                                                                           | 位置     |
| ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [BMCV用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/bmcv/html/index.html)              | BMCV 提供了一套基于 Sophon AI 芯片优化的机器视觉库，可对图像处理和张量运算加速，通过利用芯片TPU 、VPP、JPU等模块，可以完成色彩空间转换、尺度变换、仿射变换、透射变换、线性变换、画框、JPEG 编解码、BASE64 编解码、NMS、 排序、特征匹配等操作。 | 官网文档中心 |
| [BMLang用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/bmlang/html/index.html)          | 面向TPU的高级编程语言                                                                                                                                 | 官网文档中心 |
| [BMLib用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/bmlib/html/index.html)            | BMLib 是在内核驱动之上封装的一层底层软件库，负责设备Handle的管理、内存管理、数据搬运、API的发送和同步、A53使能、设置TPU工作频率等                                                                  | 官网文档中心 |
| [多媒体用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/multimedia\_guide/html/index.html)  | 驱动VPU进行视频编解码等多媒体相关                                                                                                                           | 官网文档中心 |
| [NNToolChain用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/index.html)       | 模型转换工具套件用户手册，包含模型转换、运行时库以及自定义层如何实现等方面的介绍                                                                                                     | 官网文档中心 |
| [OKKernel用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/okkernel/html/index.html)      |                                                                                                                                              | 官网文档中心 |
| [量化工具用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/index.html) | int8量化工具手册                                                                                                                                   | 官网文档中心 |
| [SAIL用户开发手册](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)  | SAIL高级接口编程库                                                                                                                                  | 官网文档中心 |
| [FAQ文档](https://doc.sophgo.com/docs/docs\_latest\_release/faq/html/index.html)                    | Sophon设备和SDK使用常见问题及解答                                                                                                                        | 官网文档中心 |
