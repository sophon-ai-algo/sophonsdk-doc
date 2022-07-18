# Table of contents

* [SophonSDK3 开发指南](README.md)

## 1 SDK软件包 <a href="#sophonsdk" id="sophonsdk"></a>

* [1.1 SDK 简介](sophonsdk/overview.md)
* [1.2 资料简介](sophonsdk/intro.md)
* [1.3 获取SDK](sophonsdk/get.md)
* [1.4 安装SDK](sophonsdk/setup/README.md)
  * [1.4.1 环境配置-Linux](sophonsdk/setup/on-linux.md)
  * [1.4.2 环境配置-Windows](sophonsdk/setup/on-windows10.md)
  * [1.4.3 环境配置-SoC](sophonsdk/setup/on-soc.md)
* [1.5 更新SDK](sophonsdk/update.md)
* [1.6 SDK更新记录](sophonsdk/notes.md)
* [1.7 SDK已知问题](sophonsdk/issues.md)

## 2 快速入门 <a href="#get_started" id="get_started"></a>

* [2.1 移植开发综述](get\_started/overview.md)
* [2.2 重要概念](get\_started/info.md)
* [2.3 样例程序](get\_started/examples.md)

## 3 网络模型迁移 <a href="#model-convert" id="model-convert"></a>

* [3.1 模型迁移概述](model-convert/intro.md)
* [3.2 FP32 模型生成](model-convert/fp32-bmodel.md)
* [3.3 INT8 模型生成](model-convert/int8-bmodel/README.md)
  * [3.3.1 准备lmdb数据集](model-convert/int8-bmodel/lmdb.md)
  * [3.3.2 生成FP32 Umodel](model-convert/int8-bmodel/fp32-umodel.md)
  * [3.3.3 生成INT8 Umodel](model-convert/int8-bmodel/int8-umodel.md)
  * [3.3.4 精度测试](model-convert/int8-bmodel/acc-test.md)
  * [3.3.5 生成INT8 Bmodel](model-convert/int8-bmodel/int8-bmodel.md)
  * [3.3.6 auto\_cali一键量化工具](model-convert/int8-bmodel/3.3.6-autocali-yi-jian-liang-hua-gong-ju.md)

## 4 算法移植 <a href="#alg-optimize" id="alg-optimize"></a>

* [4.1 算法移植概述](alg-optimize/intro.md)
* [4.2 C/C++编程详解](alg-optimize/c\_cpp.md)
* [4.3 Python编程详解](alg-optimize/python.md)
* [4.4 解码模块](alg-optimize/decoder.md)
* [4.5 图形运算加速模块](alg-optimize/bmcv.md)
* [4.6 模型推理](alg-optimize/inference.md)

## 5 打包和发布 <a href="#deploy" id="deploy"></a>

* [5.1 概述](deploy/intro.md)
* [5.2 PCIE加速卡模式](deploy/pcie.md)
* [5.3 SOC模式](deploy/soc.md)

***

* [附录](appendix.md)
