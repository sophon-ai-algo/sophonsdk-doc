# 3.3.1 准备lmdb数据集

我们需要将原始量化数据集转换成lmdb格式，供后续校准量化工具Quantization-tools 使用。

{% hint style="info" %}
**Quantization-tools对数据格式的要求：**

* Quantization-tools 对输入数据的格式要求是 \[N,C,H,W] ：即先按照 W 存放数据，再按照 H 存放 数据，依次类推&#x20;
* Quantization-tools 对输入数据的 C 维度的存放顺序与原始框架保持一致：例如 caffe 框架要求的 C 维度存放顺序是 BGR；tensorflow 要求的 C 维度存放顺序是 RGB
{% endhint %}

将数据转换成 lmdb 数据集有两种方法：&#x20;

1. 使用 [auto\_cali一键量化工具](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#auto-calib-use) 工具，将图片目录转化为lmdb供分步量化使用；
2. 运用U-FrameWork接口，在网络推理过程中或编写脚本将网络推理输入抓取存成lmdb，方法请参考 create\_lmdb。与LMDB相关的功能已经独立成为ufwio包，该安装包不再依赖Sophgo的SDK，可以在任何Python3.5及以上环境下运行。

在U-FrameWork中，网络的输入数据使用LMDB形式保存，作为data layer的数据来源。对于一般简单的情况，只需将量化输入图片进行解码和格式转换就可以了， 推荐在制作LMDB过程中即进行减均值除方差等操作，lmdb中保存前处理后的数据。而对于前处理不能精确表达的复杂处理， 或者在级联网络中需要把中间结果作为下一级网络的输入进行训练的情况，用户可以自己开发预处理脚本，直接生成lmdb。

SophonSDK中提供了一套ufwio包，提供了一系列API帮助用户构建LMDB，该包已与SophonSDK解耦，可以在任何Pyhton3.5及以上环境中安装运行，具体请参考《量化工具用户开发手册》[准备LMDB数据集](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#lmdb)。

examples中提供了创建lmdb的示例程序： [示例2：create\_lmdb\_demo](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter8.html#create-lmdb-demo) ，此示例程序可以直接作为工具使用也可以在其基础上修改加入自定义的预处理。

如何使用生成的lmdb在 [使用LMDB数据集](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#using-lmdb) 中描述，配合其中描述的前处理为量化期间的推理准备好数据。
