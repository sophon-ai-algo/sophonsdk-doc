# 3.1 模型迁移概述

​用户首先需要进行模型迁移，把其他框架下训练好的模型转换为能够运行于算丰Sophon TPU平台上的定制模型BModel。

当前Sophon SDK已支持绝大部分开源的 Caffe、Darknet、MXNet、ONNX、PyTorch、TensorFlow、Paddle Paddle等框架下的算子和模型，更多的网络层和模型也在持续支持中。关于对算子和模型的支持情况，请查看[《NNToolChain用户开发手册》](https://doc.sophgo.com/docs/3.0.0/docs\_latest\_release/nntc/html/index.html)。

| # | 深度学习框架        | 版本要求                                                                                         | 使用的bmnetx模型编译器 |
| - | ------------- | -------------------------------------------------------------------------------------------- | -------------- |
| 1 | Caffe         | 官方版本                                                                                         | bmnetc         |
| 2 | Darknet       | 官方版本                                                                                         | bmnetd         |
| 3 | MXNet         | mxnet>=1.3.0                                                                                 | bmnetm         |
| 4 | ONNX          | <p>onnx == 1.7.0</p><p>(Opset version == 12)<br>onnxruntime == 1.3.0<br>protobuf >=3.8.0</p> | bmneto         |
| 5 | PyTorch       | pytorch>=1.0.0                                                                               | bmnetp         |
| 6 | TensorFlow    | tensorflow>=1.10.0                                                                           | bmnett         |
| 7 | Paddle Paddle | paddlepaddle>=2.1.1                                                                          | bmpaddle       |

我们提供了NNToolChain工具套件帮助用户实现模型迁移。对于BM1684平台来说，它既支持float32模型，也支持int8量化模型。其模型转换流程以及章节介绍如图：

![模型转换流程及对应章节介绍图](<../.gitbook/assets/模型转换 (1).png>)

如果需要运行fp32 BModel，请参考[3.2 FP32模型生成](fp32-bmodel.md)章节。

如果需要运行in8 BModel，需要先准备量化数据集、将原始模型转换为fp32 UModel、再使用量化工具量化为int8 UModel、最后使用bmnetu编译为int8 BModel，具体请依次参考[3.3 INT8模型生成](int8-bmodel/)章节。[\
](https://1684.gitbook.io/bmnnsdk2-1684-2-0-1/on-windows10)

![](https://blobscdn.gitbook.com/v0/b/gitbook-28427.appspot.com/o/assets%2F-LufSofvg6JXrqEew0Gt%2F-Lufo9im7-linXRqaRCB%2F-Lufofcitdz9oW4NJaZ0%2F3.png?alt=media\&token=f2a5b343-3ac4-4d54-8d91-f4a37e10f5ae)

NNToolChain工具套件提供了bmnetc、bmnetd、bmnetm、bmneto、bmnetp、bmnett、bmnetu等工具，分别用来转换Caffe、Darknet、MXNet、ONNX、Pytorch、Tensorflow、UFramework（算能科技自定义的模型中间格式框架）等框架下的模型：经前端工具解析后，模型编译器BMNet Compiler会对各种框架的模型进行离线转换，生成 TPU 能够执行的指令流并序列化保存为BModel文件；当执行在线推理时， 由BMRuntime负责BModel模型的读取、数据的拷贝传输、TPU推理的执行以及计算结果的读取等。

{% hint style="info" %}
当用户模型中所需要使用的网络层或算子不被 BMNNSDK 所支持，需要开发自定义算子或层时，可以使用我们提供的**BMNET 前端插件**，在已提供的 BMNET 模型编译器的基础上增加用户自定义层或者算子。目前支持以下几种实现自定义层或算子的方式：

1. **基于BMLang开发：**BMLang 是一种面向 Sophon TPU 的上层编程语言，适用于编写高性能的深度学习、图像处理、矩 阵运算等算法程序。我们提供了基于 C++ 和基于 Python 两种 BMLang 编程接口。详情请参考SDK中document目录下的用户手册《BMLang.pdf》。
2. **基于 BMCPU 开发：**BMCPU 支持用户对 TPU 不能实现的 layer 进行 CPU 编程。详情请参考SDK中document目录下的用户手册《NNToolChain.pdf》中的6.4节“ BMCPU插件使用”。
3. **基于 OKKernel （TPUKernel）开发：**OKKernel（TPUKernel） 是面向用户推出的针对 Sophon TPU 的底层编程模型，通过根据芯片底层指令集封装的一套原子操作接口，向用户最大程度提供芯片的可编程能力。详情下载网页版[《OKKernel用户开发文档》](https://doc.sophgo.com/docs/3.0.0/docs\_latest\_release/okkernel/html/index.html)。

若您在使用过程中遇到问题，可联系算能科技获取技术支持。
{% endhint %}
