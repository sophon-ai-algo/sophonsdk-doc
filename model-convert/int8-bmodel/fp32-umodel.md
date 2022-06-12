# 3.3.2 生成FP32 Umodel

为了将第三方框架训练后的网络模型量化，需要先将它们转化为量化平台私有格式fp32 Umodel。

{% hint style="info" %}
本阶段会生成一个\*.fp32umodel文件以及一个\*_.prototxt_文件。

_prototxt_文件的文件名一般是_net\_name\_bmnetX\_test\_fp32.prototxt_，其中_X_代表原始框架名的首字母，比如_TensorFlow_的网络转为U_model_后_prototxt_文件名会是_net\_name\_bmnett\_test\_fp32.prototxt_，_PyTorch_转换的网络会是_net\_name\_bmnetp\_test\_fp32.prototxt_等。

此阶段生成的 fp32umodel 文件是量化的输入，using-lmdb 中修改预处理就是针对此阶段生成的 prototxt 文件的修改。
{% endhint %}

{% hint style="warning" %}
**注意：**基于精度方面考虑输入_Calibration-tools_的_fp32 umodel_需要保持_BatchNorm_层以及_Scale_层独立。当您利用第三方工具对网络图做一些等价转换优化时，请确保_BatchNorm_以及_Scale_层不被提前融合到_Convolution_。
{% endhint %}

{% hint style="warning" %}
**此阶段的参数设置需要注意：**&#x20;

*   如果指定了“-D (-dataset )”参数，那么需要保证“-D”参数下的路径正确，同时指定的数据集兼容该网络，否则会有运行错误。

    若指定了“-D”参数，则按照章节 using-lmdb 方法修改 prototxt。&#x20;

    * 使用 data layer 作为输入&#x20;
    * 正确设置数据预处理&#x20;
    * 正确设置 lmdb 的路径
* 在不能提供合法的数据源时，不应该使用“-D”参数（该参数是可选项，不指定会使用随机数据测 试网络转化的正确性，可以在转化后的网络中再手动修改数据来源）
* 转化模型的时候可以指定参数“–cmp”，使用该参数会比较模型转化的中间格式与原始框架下的模 型计算结果是否一致，增加了模型转化的正确性验证。
{% endhint %}

此阶段生成_fp32 umodel使用_的工具为一系列名为_ufw.tools.\*_\_to\_umodel的python脚本，存放于ufw包中，\*号代表不同框架的缩写，可以通过以下命令查看使用帮助：

```bash
# Caffe模型转化fp32umodel工具
python3 -m ufw.tools.cf_to_umodel --help
# Darknet模型转化fp32umodel工具
python3 -m ufw.tools.dn_to_umodel --help
# MxNet模型转化fp32umodel工具
python3 -m ufw.tools.mx_to_umodel --help
# ONNX模型转化fp32umodel工具
python3 -m ufw.tools.on_to_umodel --help
# PyTorch模型转化fp32umodel工具
python3 -m ufw.tools.pt_to_umodel --help
# TensorFlow模型转化fp32umodel工具
python3 -m ufw.tools.tf_to_umodel --help
# PaddlePaddle模型转化fp32umdoel工具
python3 -m ufw.tools.pp_to_umodel --help
```

详细参数说明针对不同框架稍有区别。用户可以在命令行直接使用`python3 -m ufw.tools.**_to_umodel` 加参数进行转换，或根据[examples](https://github.com/sophon-ai-algo/examples)仓库中calibartion下提供的示例程序，在其基础上修改其中的少量参数完成自己的模型转换。

更多详细内容，请参考[《量化工具用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#fp32umodel)。
