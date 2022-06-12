# 4.3 Python编程详解

SophonSDK通过SAIL库向用户提供Python编程接口。

SAIL (Sophon Artificial Intelligent Library) 是 Sophon Inference 中的核心模块。SAIL 对 BMNNSDK 中的 BMLib、BMDecoder、BMCV、BMRuntime 进行了封装，将 BMNNSDK 中原有的“加载 bmodel 并驱动 TPU 推理”、“驱动 TPU 做图像处理”、“驱动 VPU 做图像和视频解码”等功能抽象成更为简单 的 C++ 接口对外提供；并且使用 pybind11 再次封装，提供简洁易用的 python 接口。&#x20;

这个章节将会选取SSD检测算法作为示例， 来介绍python接口编程。

{% hint style="info" %}
**样例代码路径：**examples/simple/ssd/python/py\_ffmpeg\_bmcv\_sail
{% endhint %}

目前，SAIL 模块中所有的类、枚举、函数都在“sail”命名空间下，核心的类包括：

* Handle：SDK中BMLib的bm\_handle\_t的包装类，设备句柄，上下文信息，用来和内核驱动交互 信息。
* Tensor：SDK中BMLib的包装类，封装了对device memory的管理以及与system memory的同步。
* Engine：SDK中BMRuntime的包装类，可以加载bmodel并驱动TPU进行推理。一个Engine实例可以加载一个任意的bmodel，自动地管理输入张量与输出张量对应的内存。
* Decoder：使用VPU解码视频，JPU解码图像，均为硬件解码。
* &#x20;Bmcv：SDK中BMCV的包装类，封装了一系列的图像处理函数，可以驱动 TPU 进行图像处理。

其他关于接口的更相信的信息，请阅读[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。

本章主要介绍以下三点内容：

* 加载模型
* 预处理
* 推理

## 4.3.1 加载模型

```python
import sophon.sail as sail
engine = sail.Engine(tpu_id = 0)
engine.load(bmodel_path)
# engine = sail.Engine(bmodel_path,tpu_id,mode)
```

## 4.3.2 预处理

```python
class PreProcessor:
  def __init__(self, bmcv, scale):
    self.bmcv  = bmcv
    self.ab    = [x * scale for x in [1, -123, 1, -117, 1, -104]]

  def process(self, input, output):
    tmp = self.bmcv.vpp_resize(input, 300, 300)
    self.bmcv.convert_to(tmp, output, ((self.ab[0], self.ab[1]), (self.ab[2], self.ab[3]), (self.ab[4], self.ab[5])))

bmcv = sail.Bmcv(handle)   #图形处理加速模块
scale = engine.get_input_scale(graph_name, input_name)
pre_processor = PreProcessor(bmcv, scale)  #预处理初始化

img0 = decoder.read(handle)            #解码视频输出image
img1 = bmcv.tensor_to_bm_image(input)  #将推理的输入地址挂载到image

pre_processor.process(img0, img1)      #预处理
```

## 4.3.3 推理

```python
graph_name = engine.get_graph_names()[0]
engine.set_io_mode(graph_name, sail.IOMode.SYSO)

input_name   = engine.get_input_names(graph_name)[0]
output_name  = engine.get_output_names(graph_name)[0]

input_shape  = [1, 3, 300, 300]
output_shape = [1, 1, 200, 7]

handle = engine.get_handle()

input_dtype  = engine.get_input_dtype(graph_name, input_name)
output_dtype = engine.get_output_dtype(graph_name, output_name)

input  = sail.Tensor(handle, input_shape,  input_dtype,  False, True)
output = sail.Tensor(handle, output_shape, output_dtype, True,  True)

input_tensors  = { input_name:  input  }
output_tensors = { output_name: output }
...
#此处省略 解码，预处理 代码
...
engine.process(graph_name, input_tensors, output_tensors) #推理
out = output.asnumpy()

dets = post_processor.process(out, img0.width(), img0.height())  #后处理
...
```
