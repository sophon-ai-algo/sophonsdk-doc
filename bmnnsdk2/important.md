# 1.3 基本概念介绍

### 1.3.1 工作模式

算丰BM1684系列芯片产品涵盖了从末端到边缘到中枢的多种产品形态，可以支持两种不同的工作模式，分别对应不同的产品形态，具体信息如下：

| BM1684     | **SoC模式**                   | **PCIE模式**                  |
| ---------- | --------------------------- | --------------------------- |
| **独立运行**   | 是，BM1684即为独立主机，算法运行在BM1684上 | 否，算法部署在X86或ARM主机，推理运行在PCIE卡 |
| **对外IO方式** | 千兆以太网                       | PCIE接口                      |
| **对应产品**   | SE5/SM5                     | SC5/SC5H/SC5+               |

​ BM1684的软件接口在两种工作模式下是基本相同的，BMNNSDK2同时支持两种模式，此外还提供了CModel模式作为芯片的软件模拟器，支持在没有相关硬件设备的情况下实现模型转换、部分算法验证等功能。本文在进行实例演示的时候，会进行相应的标注。

### 1.3.2 硬件内存

内存是BM1684应用调试中经常会涉及的重要概念，特别地，有以下3个概念需要特别区分清楚：Global Memory、Host Memory、Device Memory。

* **全局内存（Global Memory）**：指BM1684的片外存储DDR，通常为12GB，最大支持定制为16GB。
* **设备内存（Device Memory）和系统内存（Host Memory）**：根据BM168x产品类型或工作模式的不同，设备内存和系统内存具有不同的含义：

|                   | **Soc模式**                                                 | **PCIE模式**                                                 |
| ----------------- | --------------------------------------------------------- | ---------------------------------------------------------- |
| **产品**            | SM5/SE5                                                   | SC5/SC5H/SC5+                                              |
| **Global Memory** | <p>4GB A53专用 +</p><p>4GB TPU专用 + </p><p>4GB VPP/VPU专用</p> | <p>4GB TPU专用 + </p><p>4GB VPU专用 + </p><p>4GB VPP/A53专用</p> |
| **Host Memory**   | 芯片上主控Cortex A53的内存                                        | 主机内存                                                       |
| **Device Memory** | 划分给TPU/VPP/VPU的设备内存                                       | PCIE板卡上的物理内存（Global Memory）                                |

内存同步问题是后续应用调试中经常会遇到的比较隐蔽的重要问题。我们在BM-OpenCV和BM-FFmpeg两个框架内都提供了内存同步操作的函数；而BMCV API只面向设备内存操作，因此不存在内存同步的问题，在调用BMCV API前，需要将输入数据在设备内存上准备好；我们在BMLib中提供了接口，可以实现Host Memory和Global Memory之间、Global Memory内部以及不同设备的Global Memory之间的数据搬运。更多详细信息请参考[《BMLib用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/bmlib/html/index.html)和[《多媒体用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/multimedia\_guide/html/index.html)。

### 1.3.3 BModel

**BModel：**是一种面向算能TPU处理器的深度神经网络模型文件格式，其中包含目标网络的权重（weight）、TPU指令流等等。

**Stage：**支持将同一个网络的不同batch size的模型combine为一个BModel；同一个网络的不同batch size的输入对应着不同的stage，推理时BMRuntime会根据输入shape 的大小自动选择相应stage的模型。也支持将不同的网络combine为一个BModel，通过网络名称来获取不同的网络。

**动态编译和静态编译：**支持模型的动态编译和静态编译，可在转换模型时通过参数设定。动态编译的BModel，在Runtime时支持任意小于编译时设置的shape的输入shape；静态编译的BModel，在Runtime时只支持编译时所设置的shape。

{% hint style="info" %}
**优先使用静态编译的模型：**

动态编译模型运行时需要BM1684内微控制器ARM9的参与，实时地根据实际输入shape，动态生成TPU运行指令。因此，动态编译的模型执行效率要比静态编译的模型低。若可以，应当优先使用静态编译的模型或支持多种输入shape的静态编译模型。
{% endhint %}

### 1.3.4 bm\_image

```cpp
typedef enum bm_image_format_ext_{
    FORMAT_YUV420P,
    FORMAT_YUV422P,
    FORMAT_YUV444P,
    FORMAT_NV12,
    FORMAT_NV21,
    FORMAT_NV16,
    FORMAT_NV61,
    FORMAT_RGB_PLANAR,
    FORMAT_BGR_PLANAR,
    FORMAT_RGB_PACKED,
    FORMAT_BGR_PACKED,
    PORMAT_RGBP_SEPARATE,
    PORMAT_BGRP_SEPARATE,
    FORMAT_GRAY,
    FORMAT_COMPRESSED
} bm_image_format_ext;

typedef enum bm_image_data_format_ext_{
    DATA_TYPE_EXT_FLOAT32,
    DATA_TYPE_EXT_1N_BYTE,
    DATA_TYPE_EXT_4N_BYTE,
    DATA_TYPE_EXT_1N_BYTE_SIGNED,
    DATA_TYPE_EXT_4N_BYTE_SIGNED,
}bm_image_data_format_ext;

// bm_image结构体定义如下
struct bm_image {
    int width;
    int height;
    bm_image_format_ext image_format;
    bm_data_format_ext data_type;
    bm_image_private* image_private;
};
```

BMCV API均是围绕bm\_image来进行的，一个 bm\_image 对象对应于一张图片。用户通过 bm\_image\_create构建 bm\_image 对象，attach到device memory；使用完需要调用 bm\_image\_destroy 销毁；手动attach到device memory的还需要手动释放；不同BMCV API支持的image\_format和data\_type不同，注意格式要求，必要时需要进行格式转换；更多详细信息请参考[《BMCV用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/bmcv/html/index.html)_。_

_SAIL库中将bm\_image封装为了BMImage，_相关信息请参考[《_SAIL用户开发手册_》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。
