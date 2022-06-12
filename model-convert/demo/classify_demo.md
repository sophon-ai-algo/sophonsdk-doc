# 3.4.2 classify\_demo

classify\_demo位于：${BMNNSDK}/examples/calibration/classify\_demo

classify\_demo主要演示如何将fp32 umodel(resnet18.prototxt、resnet18.fp32umodel)转换为int8 umodel，并验证量化后int8模型的精度；目录下自带lmdb文件和restnet18 fp32 umodel。

### 3.4.2.1 测试脚本函数介绍

{% hint style="info" %}
**`./classify_demo.sh`中提供了以下几个函数供参考使用**

* convert\__to\_int8\_demo：将fp32 umodel转化为int8 umodel_
* _test\_fp32\_demo：使用ufw测试fp32 umodel_
* _test\_int8\_demo：使用ufw测试int8 umodel_
* _dump\_tensor\_fp32\_demo：保存fp32 umodel的输入输出_
* _dump\_tensor\_int8\_demo：保存int8 umodel的输入输出_
{% endhint %}

用户可以根据需要参考`./classify_demo.sh`文件的函数执行命令，使用`source classify_demo.sh`可以使能脚本中的函数，以便在命令行中直接使用这些函数：

```bash
# 切换工作目录
cd /workspace/examples/calibration/classify_demo
# 使能脚本中函数，这样就可以在命令行中直接使用脚本中的函数了
source classify_demo.sh
```

### 3.4.2.2 fp32 umodel转换为int8 umodel

在命令行中执行`convert_to_int8_demo`，生成int8 umodel：

```bash
# 以下为命令行输出
......

I1206 13:23:29.258087   972 cali_core.cpp:1941]
I1206 13:23:29.258093   972 cali_core.cpp:1942] calibration for layer = acc/top-5
I1206 13:23:29.258097   972 cali_core.cpp:1943]  id=83 type:Accuracy ...
I1206 13:23:29.258105   972 cali_core.cpp:2063] Do nothing for Layer 83 of Type Accuracy with no blobs
I1206 13:23:29.258111   972 cali_core.cpp:2072]  intput 0: set_scaleconvertbacktofloat_input_mul =0.189022
I1206 13:23:29.258118   972 cali_core.cpp:2072]  intput 1: set_scaleconvertbacktofloat_input_mul =1.18394
I1206 13:23:29.258123   972 cali_core.cpp:2076]  output 0 set_scaleconvertbacktofloat_output_mul =0.000494048
I1206 13:23:29.258131   972 cali_core.cpp:2079]  forward_with_float = 0
I1206 13:23:29.258137   972 cali_core.cpp:2080]  output_is_float = 0
I1206 13:23:29.258144   972 cali_core.cpp:2081]  is_shape_layer  = 0
I1206 13:23:29.258150   972 cali_core.cpp:2082]  use_max_as_th =0

I1206 13:23:32.369089   972 cali_core.cpp:2268] used time=0 hour:0 min:7 sec
I1206 13:23:32.369168   972 cali_core.cpp:2270] int8 calibration done.
#INFO: Run Example (Resnet18 Fp32ToInt8) Done
```

转换好的int8 umodel文件将被保存在models目录下:

```bash
cd /workspace/examples/calibration/classify_demo
tree
# 以下为命令行输出
#|-- classify_demo.sh
#|-- lmdb
#|   `-- imagenet_s
#|       `-- ilsvrc12_val_lmdb
#|           |-- data.mdb
#|           `-- lock.mdb
#|-- models
#|   |-- resnet18.fp32umodel
#|   |-- resnet18.int8umodel
#|   |-- resnet18.prototxt
#|   |-- resnet18_deploy_fp32_unique_top.prototxt
#|   |-- resnet18_deploy_int8_unique_top.prototxt
#|   |-- resnet18_test_fp32_unique_top.prototxt
#|   `-- resnet18_test_int8_unique_top.prototxt
#`-- ......
```

### 3.4.2.3 int8umodel 测试

您也可以命令行中直接执行`test_int8_demo`，这将同时执行int8 umodel的生成和测试，打印top\_k的置信度，输出如下：

```bash
# 以下为命令行输出内容
......

I1206 13:30:14.015234  1058 net_cfg.cpp:263] UFW Forward(82): acc/top-1 , Accuracy ...
I1206 13:30:14.015241  1058 accuracy_layer.cpp:101] use un-unique top_k
I1206 13:30:14.015245  1058 accuracy_layer.cpp:115] label:831
I1206 13:30:14.015259  1058 net_cfg.cpp:263] UFW Forward(83): acc/top-5 , Accuracy ...
I1206 13:30:14.015264  1058 accuracy_layer.cpp:101] use un-unique top_k
I1206 13:30:14.015267  1058 accuracy_layer.cpp:115] label:831
I1206 13:30:14.015282  1058 ufw.cpp:292] Batch 9, acc/top-1 = 0
I1206 13:30:14.015305  1058 ufw.cpp:292] Batch 9, acc/top-5 = 1
I1206 13:30:14.015311  1058 ufw.cpp:297] Batch 9 Finished
I1206 13:30:14.015314  1058 ufw.cpp:300] Loss: 0
I1206 13:30:14.015331  1058 ufw.cpp:319] acc/top-5 = 0.9
I1206 13:30:14.015341  1058 ufw.cpp:327] mean score of Accuracy5-acc/top-5 is 0.9
I1206 13:30:14.015354  1058 ufw.cpp:319] acc/top-1 = 0.7
I1206 13:30:14.015358  1058 ufw.cpp:327] mean score of Accuracy1-acc/top-1 is 0.7
use time=0.000000 : 0.000000 : 5.418000
#INFO: Test Resnet-INT8 Done
```

### 3.4.2.4 其他测试

您还可以运行脚本中的其他函数，对比验证fp32 umodel以及int8 umodel的精度差异。
