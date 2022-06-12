# Table of contents

* [BM1684 BMNNSDK2 入门手册](README.md)

## 一、BMNNSDK2软件包 <a href="#bmnnsdk2" id="bmnnsdk2"></a>

* [1.1 BMNNSDK2 简介](bmnnsdk2/intro.md)
* [1.2 BMNNSDK2 文档](bmnnsdk2/documents.md)
* [1.3 基本概念介绍](bmnnsdk2/important.md)
* [1.4 获取BMNNSDK2 SDK](bmnnsdk2/get.md)
* [1.5 安装BMNNSDK2 SDK](bmnnsdk2/setup/README.md)
  * [1.5.1 环境配置-Linux](bmnnsdk2/setup/on-linux.md)
  * [1.5.2 环境配置-Windows](bmnnsdk2/setup/on-windows10.md)
  * [1.5.3 环境配置-SoC](bmnnsdk2/setup/on-soc.md)
* [1.6 更新BMNNSDK](bmnnsdk2/update.md)
* [1.7 参考样例简介](bmnnsdk2/1.7-can-kao-yang-li-jian-jie.md)
* [1.8 BMNNSDK2更新记录](bmnnsdk2/1.8-bmnnsdk2-geng-xin-ji-lu.md)
* [1.9 BMNNSDK2已知问题](bmnnsdk2/1.9-bmnnsdk2-yi-zhi-wen-ti.md)

## 二、快速入门 <a href="#tutorial" id="tutorial"></a>

* [2.1 跑通第一个例子：综述](tutorial/intro.md)
* [2.2 跑通第一个例子：模型迁移](tutorial/model-convert.md)
* [2.3 跑通第一个例子：算法迁移](tutorial/alg-optimize.md)

## 三、网络模型迁移 <a href="#model-convert" id="model-convert"></a>

* [3.1 模型迁移概述](model-convert/intro.md)
* [3.2 FP32 模型生成](model-convert/fp32-bmodel/README.md)
  * [3.2.1 编译Caffe模型](model-convert/fp32-bmodel/caffe.md)
  * [3.2.2 编译TensorFlow模型](model-convert/fp32-bmodel/tf.md)
  * [3.2.3 编译MXNet模型](model-convert/fp32-bmodel/mxnet.md)
  * [3.2.4 编译PyTorch模型](model-convert/fp32-bmodel/pt.md)
  * [3.2.5 编译 Darknet 模型](model-convert/fp32-bmodel/darknet.md)
  * [3.2.6 编译ONNX模型](model-convert/fp32-bmodel/onnx.md)
  * [3.2.7 编译Paddle模型](model-convert/fp32-bmodel/3.2.7-bian-yi-paddle-mo-xing.md)
* [3.3 INT8 模型生成](model-convert/int8-bmodel/README.md)
  * [3.3.1 准备lmdb数据集](model-convert/int8-bmodel/lmdb.md)
  * [3.3.2 生成FP32 Umodel](model-convert/int8-bmodel/fp32-umodel.md)
  * [3.3.3 生成INT8 Umodel](model-convert/int8-bmodel/int8-umodel.md)
  * [3.3.4 精度测试](model-convert/int8-bmodel/acc-test.md)
  * [3.3.5 生成INT8 Bmodel](model-convert/int8-bmodel/int8-bmodel.md)
  * [3.3.6 auto\_cali一键量化工具](model-convert/int8-bmodel/3.3.6-autocali-yi-jian-liang-hua-gong-ju.md)
* [3.4 实例演示](model-convert/demo/README.md)
  * [3.4.1 create\_lmdb\_demo](model-convert/demo/create\_lmdb\_demo.md)
  * [3.4.2 classify\_demo](model-convert/demo/classify\_demo.md)
  * [3.4.3 face\_demo](model-convert/demo/face\_demo.md)

## 四、算法移植 <a href="#alg-optimize" id="alg-optimize"></a>

* [4.1 算法移植概述](alg-optimize/intro.md)
* [4.2 C/C++编程详解](alg-optimize/c\_cpp.md)
* [4.3 Python编程详解](alg-optimize/python.md)
* [4.4 解码模块](alg-optimize/decoder.md)
* [4.5 图形运算加速模块](alg-optimize/bmcv.md)
* [4.6 模型推理](alg-optimize/inference.md)
* [4.7 实例演示](alg-optimize/demos.md)

## 五、打包和发布 <a href="#deploy" id="deploy"></a>

* [5.1 概述](deploy/5.1-gai-shu.md)
* [5.2 PCIE加速卡模式](deploy/deploy.md)
* [5.3 SOC模式](deploy/5.3-soc-mo-shi.md)

***

* [附录](appendix.md)
