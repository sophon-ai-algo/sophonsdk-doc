# 3.3.1 准备lmdb数据集

我们需要将原始量化数据集转换成lmdb格式，供后续校准量化工具Quantization-tools 使用。

{% hint style="info" %}
**Quantization-tools对数据格式的要求：**

* Quantization-tools 对输入数据的格式要求是 \[N,C,H,W] ：即先按照 W 存放数据，再按照 H 存放 数据，依次类推&#x20;
* Quantization-tools 对输入数据的 C 维度的存放顺序与原始框架保持一致：例如 caffe 框架要求的 C 维度存放顺序是 BGR；tensorflow 要求的 C 维度存放顺序是 RGB
{% endhint %}

将数据转换成 lmdb 数据集有两种方法：&#x20;

1. 使用 [auto\_cali一键量化工具](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/module/chapter4.html#auto-calib-use) 工具，将图片目录转化为lmdb供分步量化使用；
2. 运用U-FrameWork接口，在网络推理过程中或编写脚本将网络推理输入抓取存成lmdb，方法请参考 create\_lmdb。与LMDB相关的功能已经独立成为ufwio包，该安装包不再依赖Sophgo的SDK，可以在任何Python3.5及以上环境下运行。

在U-FrameWork中，网络的输入数据使用LMDB形式保存，作为data layer的数据来源。对于一般简单的情况，只需将量化输入图片进行解码和格式转换就可以了， 推荐在制作LMDB过程中即进行减均值除方差等操作，lmdb中保存前处理后的数据。而对于前处理不能精确表达的复杂处理， 或者在级联网络中需要把中间结果作为下一级网络的输入进行训练的情况，用户可以自己开发预处理脚本，直接生成lmdb。

### 3.3.1.1 LMDB API组成

*   lmdb = ufwio.LMDB\_Dataset(path, queuesize=100, mapsize=20e6) # 建立一个 LMDBDataset对象，

    ```
    path: 建立LMDB的路径(会自建文件夹，并将数据内容存储在文件夹下的data.mdb)
    queuesize:  缓存队列，指缓存图片数据的个数。默认为100，增加该数值会提高读写性能，但是对内存消耗较大
    mapsize:  LMDB建立时开辟的内存空间，LMDBDataset会在内存映射不够的时候自动翻倍
    ```
*   put(data, labels=None, keys=None) # 存储图片和标签信息

    ```
    data: tensor数据，只接受numpay.array格式或是含多个numpy.array的python
    list。数据类型可以是int8/uint8/int16/uint16/int32/uint32/float32。数据会
    以原始shape存储。
    lables: 图片的lable，需要是int类型，如果没有label不填该值即可。
    keys:   LMDB的键值，可以使用原始图片的文件名，但是需要注意LMDB数据会对存储的数据按键值进行排序，推荐使用唯一且递增的键值。如果不填该值，LMDB_Dataset会自动维护一个递增的键值。
    ```
*   close()

    ```
    将缓存取内容存储，并关闭数据集。如果不使用该方法，程序会在结束的时候自动执行该方法。
    但是如果python解释器崩溃，则会导致缓存区数据丢失。
    ```
*   with Blocks

    ```
    LMDB_Dataset支持使用python with语法管理资源。
    ```

### 3.3.1.2 LMDB API使用方式

* import ufwio
* txn = ufwio.LMDB\_Dataset(‘to/your/path’)
* txn.put(images) # 放置在循环中
* 在pytorch和tensorflow中，images通常是xxx.Tensor，可以使用images.numpy()，将其转化为numpy.array格式
* txn.close()

### 3.3.1.3 示例代码

> * 使用对象方法存储数据
>
> ```python
> import ufwio
> import torch
>
> images = torch.randn([1, 3,100,100])
>
> path = "test_01"
> txn = ufwio.LMDB_Dataset(path)
>
> for i in range(1020):
>     txn.put(images.numpy())
> txn.close()
> ```
>
> * 使用with语法来管理存储过程
>
> ```python
> import ufwio
> import torch
>
> images = torch.randn([1, 3,100,100])
>
> path = "test_02"
>
> with ufwio.LMDB_Dataset(path) as db:
>     for i in range(1024):
>         db.put(images.numpy())
> ```
>
> * 读取lmdb数据
>
> ```python
> import ufwio
>
> path = "test_02"
>
> for key, arr in ufwio.lmdb_data(path):
>     print("{0} : {1}".format(key, arr)) # arr is an numpy.array
> ```
>
> * 命令行查看lmdb内容
>
> ```bash
> python3 -m ufwio.lmdb_info /path/to/your/LMDB/path
> ```

{% hint style="info" %}
**注意事项：**

* 此功能不会检查给定路径下是否已有文件，如果之前存在LMDB文件，该文件会被覆盖。
* 使用重复的key会导致数据覆盖或污染，使用非递增的key会导致写入性能下降。
* 解析该LMDB的时候需要使用Data layer。
{% endhint %}

BMNNSDK工具包中也包含了创建lmdb的示例程序： [示例2：create\_lmdb\_demo](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/module/chapter8.html#create-lmdb-demo) ，位于`bmnnsdk/examples/calibration/create_lmdb_demo`。此示例程序可以直接作为工具使用也可以在其基础上修改加入自定义的预处理。

如何使用生成的lmdb在 [使用lmdb数据集](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/module/chapter4.html#using-lmdb) 中描述，配合其中描述的前处理为量化期间的推理准备好数据。
