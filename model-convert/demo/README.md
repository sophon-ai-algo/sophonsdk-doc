# 3.4 实例演示

当前SDK内有关于模型转换的一些演示demo：

* ${BMNNSDK}/examples/nntc：fp32模型生成和BMRuntime推理库接口使用
* ${BMNNSDK}/examples/calibration：模型量化相关的工具使用

## DEMO概述

本节重点介绍以下demo，它们位于${BMNNSDK}/examples/calibration目录下:

| 示例目录               | 功能                 | 网络模型            | 输入          | 输出          |
| ------------------ | ------------------ | --------------- | ----------- | ----------- |
| create\_lmdb\_demo | 基于imageset创建lmdb文件 | 无               | image set   | lmdb        |
| classify\_demo     | 分类网络模型转换以及推理流程     | resnet18        | fp32 umodel | int8 umodel |
| face\_demo         | 人脸检测网络模型转换以及推理流程   | squeezenet\_21k | fp32 umodel | int8 umodel |

