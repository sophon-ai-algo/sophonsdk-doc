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

详细参数说明针对不同框架稍有区别，具体参考下文示例中各框架下的参数解释。

下文示例中模型生成命令已经保存为简单的python脚本，用户可以在这些脚本的基础上修改其中的少量参数完成自己的模型转换，也可以在命令行直接使用`python3 -m ufw.tools.**_to_umodel` 加参数进行转换。

### **3.3.2.1 caffe模型转换fp32umodel**&#x20;

SDK目录下examples/calibration/caffemodel\__to\_fp32umodel\_demo/_的示例中，演示了如何把Caffe版ResNet50模型转换为fp32 umodel：

```python
# 以resnet50 caffemodel 为例介绍转换为FP32 umodel
'''
This file is only for demonstrate how to use convert tools to convert
caffemodel to umodel.
'''
import os
os.environ['GLOG_minloglevel'] = '2'
import ufw.tools as tools

cf_resnet50 = [
    '-m', './models/ResNet-50-test.prototxt',
    '-w', './models/ResNet-50-model.caffemodel',
    '-s', '(1,3,224,224)',
    '-d', 'compilation',
    '--cmp'
]

if __name__ == '__main__':
    tools.cf_to_umodel(cf_resnet50)
```

在docker环境下，直接执行：

```bash
python3 resnet50_to_umodel.py
```

在当前文件夹下，新生成 compilation 文件夹，存放新生成的_._fp32umodel 与.prototxt。

* cf\_to\_umodel的命令参数：

| args   | Description                                                |
| ------ | ---------------------------------------------------------- |
| -m     | 指向模型文件\*.prototxt的路径                                       |
| -w     | 指向权重文件\*.caffemodel的路径                                     |
| -i     | 输入tensor的名称                                                |
| -o     | 输出tensor的名称                                                |
| -s     | 输入tensor的维度，(N,H,W,C)                                      |
| -d     | 输出文件夹的名字                                                   |
| -n     | 网络的名字                                                      |
| -D     | lmdb数据集的位置，没有的话，可以暂时随意填个路径，然后在手动编辑prototxt文件的时候，根据实际的路径来添加 |
| --dyn  | 是否使用动态编译                                                   |
| --desc | 输入tensor dtype类型                                           |
| --cmp  | 可选参数，指定是否测试模型转化的中间文件                                       |

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.2 TensorFlow模型转换fp32 umodel**

SDK目录下examples/calibration/tf\__to\_fp32umodel\_demo/_的示例中，演示了如何把Tensorflow版resnet50\_v2.pb转换为fp32 umodel：

```python
import os
os.environ['GLOG_minloglevel'] = '2'
import ufw.tools as tools

tf_resnet50 = [
    '-m', './models/frozen_resnet_v2_50.pb',
    '-i', 'input',
    '-o', 'resnet_v2_50/predictions/Softmax',
    '-s', '(1, 299, 299, 3)',
    '-d', 'compilation',
    '-n', 'resnet50_v2',
    '-D', '../classify_demo/lmdb/imagenet_s/ilsvrc12_val_lmdb_with_preprocess',
    '--cmp',
    '--no-transform'
]

if __name__ == '__main__':
    tools.tf_to_umodel(tf_resnet50)
    
```

在docker环境下，直接执行：

```bash
python3 resnet50_v2_to_umodel.py
```

在当前文件夹下，新生成 compilation 文件夹，存放新生成的_._fp32umodel 与.prototxt。

* tf\_to\_umodel的命令参数：

| args   | Description                                                |
| ------ | ---------------------------------------------------------- |
| -m     | 指向\*.pb文件的路径                                               |
| -i     | 输入tensor的名称                                                |
| -o     | 输出tensor的名称                                                |
| -s     | 输入tensor的维度，(N,H,W,C)                                      |
| -d     | 输出文件夹的名字                                                   |
| -n     | 网络的名字                                                      |
| -D     | lmdb数据集的位置，没有的话，可以暂时随意填个路径，然后在手动编辑prototxt文件的时候，根据实际的路径来添加 |
| --dyn  | 可选，使用动态编译                                                  |
| --desc | 可选，输入tensor dtype类型                                        |
| --cmp  | 可选，指定是否测试模型转化的中间文件                                         |

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.3 PyTorch模型转换fp32 umodel**&#x20;

SDK目录下examples/calibration/pt\_to\_fp32umodel\_demo/的示例中，演示了如何把PyTorch模型mobilenet\_v2.pt转换为fp32 umodel：

```python
import os
os.environ['BMNETP_LOG_LEVEL'] = '3'
import ufw.tools as tools

pt_mobilenet = [
    '-m', './models/mobilenet_v2.pt',
    '-s', '(1,3,224,224)',
    '-d', 'compilation',
    '-D', '../classify_demo/lmdb/imagenet_s/ilsvrc12_val_lmdb_with_preprocess',
    '--cmp'
]

if __name__ == '__main__':
    tools.pt_to_umodel(pt_mobilenet)

```

在docker环境下，直接执行：

```bash
python3 mobilenet_v2_to_umodel.py
```

在当前文件夹下，新生成 compilation 文件夹，存放新生成的.fp32umodel 与.prototxt。

* pt\_to\_umodel的命令参数：

| args   | Description                                                |
| ------ | ---------------------------------------------------------- |
| -m     | 指向\*.pt文件的路径                                               |
| -s     | 输入tensor的维度，(N,H,W,C)                                      |
| -d     | 输出文件夹的名字                                                   |
| -D     | lmdb数据集的位置，没有的话，可以暂时随意填个路径，然后在手动编辑prototxt文件的时候，根据实际的路径来添加 |
| --dyn  | 可选，使用动态编译                                                  |
| --desc | 可选，输入tensor dtype类型                                        |
| --cmp  | 可选，指定是否测试模型转化的中间文件                                         |

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.4 MXNet模型转换fp32 umodel**&#x20;

SDK目录下examples/calibration/mx\_to\_fp32umodel\_demo/的示例中，演示了如何把MXNet mobilenet0.25模型转换为fp32 umodel：

```python
import os
os.environ['GLOG_minloglevel'] = '3'
import ufw.tools as tools

mx_mobilenet = [
    '-m', './models/mobilenet0.25-symbol.json',
    '-w', './models/mobilenet0.25-0000.params',
    '-s', '(1,3,128,128)',
    '-d', 'compilation',
    '-D', '../classify_demo/lmdb/imagenet_s/ilsvrc12_val_lmdb_with_preprocess',
    '--cmp'
]

if __name__ == '__main__':
    tools.mx_to_umodel(mx_mobilenet)
    
```

在docker环境下，直接执行：

```bash
python3 mobilenet0.25_to_umodel.py
```

若不指定-d 参数，则默认在当前文件夹下，新生成 compilation 文件夹，存放新生成的.fp32umodel 与.prototxt。

* mx\_to\_umodel的命令参数：

| args   | Description                                                |
| ------ | ---------------------------------------------------------- |
| -m     | 指向\*.json文件的路径                                             |
| -w     | 指向\*.params文件路径                                            |
| -s     | 输入tensor的维度，(N,H,W,C)                                      |
| -d     | 输出文件夹的名字                                                   |
| -D     | lmdb数据集的位置，没有的话，可以暂时随意填个路径，然后在手动编辑prototxt文件的时候，根据实际的路径来添加 |
| --dyn  | 可选，使用动态编译                                                  |
| --desc | 可选，输入tensor dtype类型                                        |
| --cmp  | 可选，指定是否测试模型转化的中间文件                                         |

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.5 Darknet模型转换fp32 umodel**

SDK目录下examples/calibration/dn\_to\_fp32umodel\_demo/的示例中，演示了如何把DarkNet YOLOV3模型转换为fp32 umodel。

```python
import ufw.tools as tools
dn_darknet = [
    '-m', 'yolov3/yolov3.cfg', 
    '-w', 'yolov3/yolov3.weights',
    '-s', '[[1,3,416,416]]',
    '-d', 'compilation'
    ] 

if __name__ == '__main__':
    tools.dn_to_umodel(dn_darknet)
```

{% hint style="info" %}
**参数解释：**

\-m     # 指向 \*.cfg 文件的路径&#x20;

\-w     # 指向 \*.weights 文件的路径&#x20;

\-s      # 输入 tensor 的维度，（N,C,H,W）&#x20;

\-d     # 生成 umodel 的文件夹&#x20;

\-D     # lmdb 数据集的位置，没有的话，可以暂时随意填个路径，然后手动编辑 prototxt 文件的时候，根据实际的路径来添加
{% endhint %}

**运行命令：**&#x20;

此示例程序发布时为了减少发布包体积，原始网络没有随SDK一块发布，要运行此示例需要先下载原始网络：

```bash
get_model.sh # download model
python3 yolov3_to_umodel.py
```

若不指定-d 参数，则默认在当前文件夹下，新生成 compilation 文件夹存放输出的 \*.fp32umodel 与 \*\_bmnetd\_test\_fp32.prototxt。

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.6 ONNX模型转换fp32 umodel**

SDK目录下examples/calibration/on\_to\_fp32umodel\_demo/的示例中，演示了如何把ONNX posenet模型转换为fp32 umodel。

```python
import ufw.tools as tools
on_postnet = [
    '-m', './models/postnet.onnx', 
    '-s', '[(1, 80, 256)]',
    '-i', '[mel_outputs]',
    '-d', 'compilation',
    '--cmp'
    ] 

if __name__ == '__main__':
    tools.on_to_umodel(on_postnet)
```

{% hint style="info" %}
**参数解释：**

\-m     # 指向 \*.onnx 文件的路径 &#x20;

\-s      # 输入 tensor 的维度，（N,C,H,W）&#x20;

\-i       # 输入 tensor 的名称

\-o      # 输出 tensor 的名称

\-d     # 生成 umodel 的文件夹&#x20;

\-D     # lmdb 数据集的位置，没有的话，可以暂时随意填个路径，然后手动编辑 prototxt 文件的时候，根据实际的路径来添加

\--cmp # 可选参数，指定是否测试模型转化的中间文件
{% endhint %}

**运行命令：**&#x20;

```bash
python3 postnet_to_umodel.py
```

若不指定-d 参数，则默认在当前文件夹下，新生成 compilation 文件夹存放输出的 \*.fp32umodel 与 \*\_bmneto\_test\_fp32.prototxt。

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。

### **3.3.2.7 PaddlePaddle模型转换fp32 umodel**

SDK目录下examples/calibration/pp\_to\_fp32umodel\_demo/的示例中，演示了如何把PaddlePaddle OCR模型转换为fp32 umodel。

```python
import os
os.environ['GLOG_minloglevel'] = '3'
import ufw.tools as tools

ppocr_rec = [
    '-m', './models/ppocr_mobile_v2.0_rec',
    '-s', '[(1,3,32,100)]',
    '-i', '[x]',
    '-o', '[save_infer_model/scale_0.tmp_1]',
    '-d', 'compilation',
    '--cmp'
]

if __name__ == '__main__':
    tools.pp_to_umodel(ppocr_rec)
```

{% hint style="info" %}
**参数解释：**

\-m     # 指向 \*.pdiparams文件所在的路径，参数到模型所在文件夹那一级；paddle模型有2种：组合式(combined model)和非复合式(uncombined model)；组合式就是_model + 权重，\_\_model\_\_文件夹下有很多文件，每一个文件是一层，这种模型名称必须用_\_\__model\_\__；如果是非组合式，一定要把模型名称修改为\*.pdmodel和\*.pdiparams

\-s      # 输入 tensor 的维度，(N,C,H,W)，shapes和descs中的变量顺序、名称要和实际模型一致，不能写错；

\-i       # 输入 tensor 的名称

\-o      # 输出 tensor 的名称

\-d     # 生成 umodel 的文件夹&#x20;

\-D     # lmdb 数据集的位置，没有的话，可以暂时随意填个路径，然后手动编辑 prototxt 文件的时候，根据实际的路径来添加

\--cmp # 可选参数，指定是否测试模型转化的中间文件
{% endhint %}

**运行命令：**&#x20;

```bash
python3 ppocr_rec_to_umodel.py
```

若不指定-d 参数，则默认在当前文件夹下，新生成 compilation 文件夹存放输出的 \*.fp32umodel 与 \*\_bmneto\_test\_fp32.prototxt。

更多详细内容，请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/calibration-tools/html/index.html)。
