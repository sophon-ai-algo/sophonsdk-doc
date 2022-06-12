# 3.3.3 生成INT8 Umodel

此流程从fp32 Umodel转换为int8 Umodel，即为量化过程。 网络量化过程包含下面两个步骤：

1. **优化网络：**对输入浮点网络图进行优化&#x20;
2. **量化网络：**对浮点网络进行量化得到 int8 网络图及系数文件&#x20;

量化需要用到[3.3.1 准备lmdb数据集](lmdb.md)中产生的 lmdb 数据集，而正确使用数据集尤为重要，所以先说明如何使用数据集。

对于 post-training 量化方法，通过将训练后的模型进行一定次数的推理，来统计每层的输入输出数据范围，从而确定量化参数。为了使统计尽可能准确，**推理时候必须保证输入的数据为实际训练/验证时 候的有效数据，前处理也保证和训练时候的一样**。&#x20;

因此 Uframework 中提供了简单的前处理接口可以对生成的 lmdb 数据进行前处理以对齐训练过程 的预处理。通过修改生成 fp32 umodel 时候生成的 \*\_test\_fp32.prototxt 文件也可配置前处理算法，生成的lmdb数据在输入网络前会按照此处的配置进行计算后再进行真正的网络推理，完整的前处理可以视为制作lmdb时进行的前处理和prototxt中定义的前处理算法的组合。

### 3.3.3.1 数据预处理

一般可以做以下 3 方面的修改：

* 使用Data layer 作为网络的输入
* 使 Data layer 的参数 data\_param 指向生成的 lmdb 数据集的位置
* 修改 Data layer 的 transform\_param 参数以对应网络对图片的预处理

data\_layer的典型结构如下例所示：

```protobuf
layer {
   name: "data"
   type: "Data"
   top: "data"
   top: "label"
   include {
      phase: TEST
   }
   transform_param {
      transform_op {
         op: RESIZE
         resize_h: 331
         resize_w: 331
      }
      transform_op {
         op: STAND
         mean_value: 128
         mean_value: 128
         mean_value: 128
         scale: 0.0078125
      }
   }
   data_param {
      source: "/my_lmdb"
      batch_size: 0
      backend: LMDB
   }
}
```

例如：

![修改fp32 umodel prototxt配置预处理](../../.gitbook/assets/fp32umodel转int8umodel修改prototxt.png)

在量化网络前，需要修改网络的 \*\_test\_fp32.prototxt 文件，在 datalayer（或者 AnnotatedData layer）添加其数据预处理的参数，以保证送给网络的数据与网络在原始框架中训练时的预处理一致。

Calibration-tools 量化工具支持两种数据预处理表示方式：

![使用 transform\_op 参数与使用 transform\_param 参数对比](../../.gitbook/assets/transform\_op\_param.png)

1. **Caffe自带的TransformationParameter 参数表示方法：**Caffe自带的表示方法各个参数的执行顺序相对固定（如上图右半部所示），但很难完善表达Tensorflow、Pytorch 等基于Python的框架里面灵活多变的预处理 方式，仅适用于 Caffe 模型的默认数据预处理方式。使用此方式，前处理操作和参数直接以 transform\_param 的参数的形式定义。
2. **算能科技自定义的TransformOp 数组表示方法：**我们定义了transform\_op结构，将需要进行的预处理分解为不同的 transform\_op，按照顺序列在transform\_param中，程序会按照顺序分别执行各项计算。&#x20;

{% hint style="warning" %}
**注意：**

* 在修改 prototxt 文件添加数据预处理时，使用transform\__param和transform_\_op定义预处理只能二选一，请优先使用_transform_\_op。&#x20;
* 关于transform\__param和transform_\_op的更详细内容请查看《Quantization-Tools-User\_Guide》中的[TransformOp定义](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#transformop)。
* 当前版本开始对lmdb有升级，制作lmdb只有python形式的接口提供，示例程序create\_lmdb提供了例程可在其基础上修改。推荐在python代码中将预处理一并包含，生成已经预处理过的数据供量化使用，这样就不必在prototxt中定义前处理。 制作lmdb时候需要生成与网络输入shape一致的数据，当此lmdb用作转换fp32umodel命令的-D参数的输入时，上述prototxt的data layer的batch\_size参数会自动设置为0，如果转换fp32umodel过程中没有指定-D参数，则<mark style="color:green;">手工修改prototxt指定数据源时需要注意将batch\_size设置为0</mark>。 <mark style="color:red;">以前版本二进制convert\_imageset工具生成的lmdb配合以前的prototxt是兼容的。</mark>
{% endhint %}

### **3.3.3.2 量化网络**

```bash
calibration_use_pb \
        quantize \ # 固定参数
        -model= PATH_TO/*.prototxt \ # 描述网络结构的文件
        -weights=PATH_TO/*.fp32umodel # 网络系数文件                
        -iterations=200 \ # 迭代次数
        -winograd=false \ # 可选参数
        -graph_transform=false \ # 可选参数
        -save_test_proto=false # 可选参数
```

{% hint style="info" %}
**命令参数：**

&#x20;  \-accuracy\_opt: 是否开启精度优化选项，开启后deptwise卷积会用浮点推理，默认关闭

&#x20;  \-bitwidth: 量化后数据宽度，默认为int8: TO\_INT8

&#x20;  \-conv\_group: 是否对卷积的channel进行分组，对于一些channel间数据差异大的channel按照范围排序分组，可以减少量化误差

&#x20;  \-dump\_dist: 量化过程中将统计的每层的数据分布保存在文件中，下次量化可以直接load，跳过推理统计的过程加速量化

&#x20;  \-fold\_concat\_scale: 将concat和scale系数合并，将concat不同输入之间的门限差别转移到scale的系数中

&#x20;  \-fpfwd\_blocks: 将某layer开始到下一个计算layer为止的区块用浮点推理

&#x20;  \-fpfwd\_inputs: 从输入到某layer之间的layers用浮点推理

&#x20;  \-fpfwd\_outputs: 从某些layer到网络输出之间的layers用浮点推理

&#x20;  \-graph\_transform: 是否进行图优化

&#x20;  \-iterations: 量化推理次数，较多的推理次数统计的数据分布往往更准确，但是需要更多的时间

&#x20;  \-load\_dist: 将上次量化保存的layer的数据分布加载进来跳过再次推理，提高推理速度，需要注意只能使用结构完全没有变化的网络保存的分布

&#x20;  \-merge\_depwise\_scale: 将depthwise的卷积和之后的scale合并，打开accuracy\_opt会默认进行此操作

&#x20;  \-merge\_scale\_to\_conv: 将卷积之后的scale合并到卷积中

&#x20;  \-model: 量化输入网络

&#x20;  \-notmerge\_conv\_layer: 当合并卷积和scale时候这些layer排除在外不要合并

&#x20;  \-pad\_value: 有pad的层的pad值

&#x20;  \-per\_channel: 对卷积尝试每channel量化

&#x20;  \-random\_input\_compare: 优化网络时默认随机输入对比，对有些网络随机输入会造成崩溃，打开此开关用网络中data layer的源数据作为输入比较，首先需要保证网络的输入设置正确

&#x20;  \-save\_test\_proto: 保存测试网络，此网络包含data layer,可用于可视化工具比较量化效果

&#x20;  \-target: 量化目标运行芯片，BM1684 or BM1686

&#x20;  \-th\_binnum: 使用KL量化算法时候可选的数据bin的个数，512-4096之间的2的幂次数值

&#x20;  \-th\_method: 计算门限的算法，可以为KL(default),SYMKL,JSD,ADMM,ACIQ,MAX,PERCENTILE9999

&#x20;  \-weights: 量化网络的权重文件

&#x20;  \-winograd: 是否使用winograd算法，针对 3x3 convolution 才有加速效果**，**是否真正使用需要在转bmodel时再次指定

**命令输出：**

• \*.int8umodel: 即量化生成的 int8 格式的网络系数文件&#x20;

• \*\_test\_fp32\_unique\_top.prototxt：&#x20;

• \*\_test\_int8\_unique\_top.prototxt：分别为 fp32, int8 格式的网络结构文件，该文件包括 datalayer 与原始 prototxt 文件的差别在于，各 layer 的输出 blob 是唯一的，不存在 in-place 的情况， 当-save\_test\_proto 为 true 时会生成这两个文件。&#x20;

• \*\_deploy\_fp32\_unique\_top.prototxt：&#x20;

• \*\_deploy\_int8\_unique\_top.prototxt：分别为 fp32，int8 格式的网络结构文件, 该文件不包括 datalayer

以上几个文件存放位置与通过参数“-weights=PATH\_TO/\*.fp32umodel”指定的文件位置相同。
{% endhint %}

### **3.3.3.3 优化网络**

默认配置下对输入浮点网络进行优化，包括：batchnorm 与 scale 合并，前处理融合到网络，删除推理过程中不必要的算子等功能。更多信息请查看${BMNNSDK}/documents下的《Quantization-Tools-User\_Guide.pdf》。

```
calibration_use_pb \
        graph_transform \ # 固定参数
        -model= PATH_TO/*.prototxt \ # 描述网络结构的文件
        -weights=PATH_TO/*.fp32umodel # 网络系数文件
```

{% hint style="info" %}
**命令输入：**

• graph\_transform：固定参数

• -model= PATH\_TO/_.prototxt：描述网络结构的文件，该 prototxt 文件的 datalayer 指向准备好 的数据集，如修改 source 指向正确的 LMDB 位置 所示。_&#x20;

• _-weights=PATH\_TO/_.fp32umodel：保存网络系数的文件。&#x20;

这两个文件由[fp32-umodel.md](fp32-umodel.md "mention")章节生成。&#x20;

**命令输出：**

• __ PATH\_TO/_.prototxt\_optimized_&#x20;

• _PATH\_TO/_.fp32umodel\_optimized

为了和原始网络模型做区分，新生成的网络模型存储的时候以“optimized”为后缀。以上两 个文件存放在与通过参数“-weights=PATH\_TO/\*.fp32umodel”指定的文件相同的路径下。
{% endhint %}

### **3.3.3.4 级联网络量化**

{% hint style="success" %}
### **级联网络量化**

级联网络的量化需要对每个网络分别进行量化，对每个网络分别准备 LMDB 和量化调优。
{% endhint %}
