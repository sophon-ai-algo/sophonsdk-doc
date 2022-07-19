---
description: 更新日期：2022年07月18日 适配版本：3.0.0_20220716
---

# SophonSDK3 开发指南

## 注意

<mark style="color:red;">**近期我们将对SDK的发布方式进行升级，改进安装使用和开发部署的用户体验。敬请期待！**</mark>

## **声明**&#x20;

**法律声明**

版权所有 © 算能 2022. 保留一切权利。

非经本公司书面许可，任何单位和个人不得擅自摘抄、复制本文档内容的部分或全部，并不得以任何形式传播。

**注意**

您购买的产品、服务或特性等应受 算能 商业合同和条款的约束， 本文档中描述的全部或部分产品、服务或特性可能不在您的购买或使用范围之内。 除非合同另有约定， 算能 对本文档内容不做任何明示或默示的声明或保证。 由于产品版本升级或其他原因，本文档内容会不定期进行更新。 除非另有约定，本文档仅作为使用指导，本文档中的所有陈述、信息和建议不构成任何明示或暗示的担保。

**技术支持**

地址**：**北京市海淀区丰豪东路9号院中关村集成电路设计园（ICPARK）1号楼

邮编**：**100094

网址**：**[https://www.sophgo.com/](https://www.sophgo.com/)

邮箱**：**[sales@sophgo.com](mailto:sales%40sophgo.com)

电话**：**+86-10-57590723 +86-10-57590724

## SophonSDK发布记录

| 版本     | 发布时间       | 说明                                                  |
| ------ | ---------- | --------------------------------------------------- |
| v2.0.0 | 2019/9/20  | First offical release                               |
| v2.0.1 | 2019/11/16 | Revised for 2.0.1                                   |
| v2.0.3 | 2020/05/07 | Revised for 2.0.3                                   |
| v2.2.0 | 2020/10/12 | Revised for 2.2.0                                   |
| v2.3.0 | 2021/01/11 | Revised for 2.3.0                                   |
| v2.3.1 | 2021/03/09 | Revised for 2.3.1                                   |
| v2.3.2 | 2021/04/01 | Revised for 2.3.2                                   |
| v2.4.0 | 2021/05/23 | Revised for 2.4.0                                   |
| v2.5.0 | 2021/09/02 | Revised for 2.5.0                                   |
| v2.6.0 | 2021/12/09 | Revised for 2.6.0                                   |
| v2.7.0 | 2022/05/31 | first released on 2022/03/16, patched on 2022/05/31 |
| v3.0.0 | 2022/07/16 | first released on 2022/07/16                        |

## 术语解释

| 术语                           | 说明                                                                          |
| ---------------------------- | --------------------------------------------------------------------------- |
| BM1684X                      | 算能科技面向深度学习领域推出的第四代张量处理器                                                     |
| BM1684                       | 算能科技面向深度学习领域推出的第三代张量处理器                                                     |
| TPU                          | BM1684芯片中的神经网络运算单元                                                          |
| VPU                          | BM1684芯片中的解码单元                                                              |
| VPP                          | BM1684芯片中的图形运算加速单元                                                          |
| JPU                          | BM1684芯片中的图像jpeg编解码单元                                                       |
| BMNNSDK2                     | 算能科技基于BM1684芯片的原创深度学习开发工具包v2                                                |
| SophonSDK                    | 算能科技基于BM168X芯片的原创深度学习开发工具包，v3.0.0开始更名为SophonSDK                             |
| PCIE Mode                    | BM1684的一种工作形态，芯片作为加速设备来进行使用，客户算法运行于x86主机                                    |
| SoC Mode                     | BM1684的一种工作形态，芯片本身作为主机独立运行，客户算法可以直接运行其上。                                    |
| CModel                       | BM1684软件模拟器，包含于BMNNSDK2中，在不具备 TPU 硬件设备的情况 下，可用于验证 BMNNSDK2编译及完成模型转换         |
| arm\_pcie Mode               | BM1684的一种工作形态，搭载芯片的板卡作为PCIe从设备插到ARM cpu的服务器上，客户算法运行于ARM cpu的主机上             |
| BMCompiler                   | 面向算能科技TPU 处理器研发的深度神经网络的优化编译器，可以将深度学习框架定义的各种深度神经网络转化为 TPU 上运行的指令流。           |
| BMRuntime                    | TPU推理接口库                                                                    |
| BMCV                         | 图形运算硬件加速接口库                                                                 |
| BMLib                        | 在内核驱动之上封装的一层底层软件库，设备管理、内存管理、数据搬运、API发 送、A53使能、功耗控制                          |
| UFramework(ufw)              | 算能自定义的基于Caffe的深度学习推理框架，用于将模型与原始框架解耦以便验证模型转换精度和完成量化                          |
| BMNetC                       | 面向Caffe的 BMCompiler 前端工具                                                    |
| BMNetD                       | 面向Darknet的BMCompiler前端工具                                                    |
| BMNetM                       | 面向MxNet的 BMCompiler 前端工具                                                    |
| BMNetO                       | 面向ONNX的BMCompiler前端工具                                                       |
| BMNetP                       | 面向PyTorch的 BMCompiler 前端工具                                                  |
| BMNetT                       | 面向TensorFlow的BMCompiler 前端工具                                                |
| BMNetU                       | INT8量化模型的BMCompiler前端工具                                                     |
| BMPaddle                     | 面向Paddle Paddle的BMCompiler前端工具                                              |
| Umodel                       | 算能自定义的UFamework下的模型格式，为量化模型时使用的中间模型格式                                       |
| BModel                       | 面向算能TPU处理器的深度神经网络模型文件格式，其中包含目标网络的权重（weight）、TPU指令流等                         |
| BMLang                       | 面向TPU的高级编程模型，用户开发时无需了解底层TPU硬件信息                                             |
| TPUKernel(OKKernel,BMKernel) | 基于TPU原子操作(根据芯片指令集封装的一套接口)的开发库，需熟悉芯片架构、存储细节                                  |
| SAIL                         | 支持Python/C++接口的Sophon Inference推理库，是对BMCV、BMDecoder、 BMLib、BMRuntime等的进一步封装 |
| winograd                     | 一种卷积的加速算法                                                                   |

## 授权

​BMNNSDK/SophonSDK是算能科技自主研发的原创深度学习开发工具包，未经算能科技事先书面授权，其它第三方公司或个人不得以任何形式或方式复制、发布和传播。

## 帮助与支持

​ 在使用过程中，如有关于SophonSDK的任何问题或者意见和建议，欢迎到[官方技术论坛](https://developer.sophgo.com/forum/index.html)提问反馈。
