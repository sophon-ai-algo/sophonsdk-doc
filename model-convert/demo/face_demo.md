# 3.4.3 face\_demo

face\_demo位于：${BMNNSDK}/examples/calibration/face\_demo

face\_demo为使用squeezenet网络进行人脸检测的演示demo，主要包括：&#x20;

1. 检测程序的编译；
2. 生成squeezennet int8 umodel；&#x20;
3. 使用squeezennet int8 umodel进行人脸检测。

### 3.4.3.1 测试脚本函数介绍

{% hint style="info" %}
**`./face_demo.sh`中提供了以下几个函数供参考使用**

* _build\_face\_demo\_fp32：编译使用fp32 umodel的检测程序_
* _build\_face\_demo\_int8：编译使用int8 umodel的检测程序_
* convert\__squeezenet\_to\__int8：将fp32 umodel转化为int8 umodel
* _detect\_squeezenet\_fp32：使用fp32 umodel进行人脸检测_
* _detect\_squeezenet\_int8：使用int8 umodel进行人脸检测_
{% endhint %}

用户可以根据需要参考`./face_demo.sh`文件的函数执行命令，更详细的说明请参考目录下《README.md》。

```bash
# 切换工作目录
cd /workspace/examples/calibration/face_demo
# 使能脚本中函数，这样就可以在命令行中直接使用脚本中的函数了
source face_demo.sh
```

### 3.4.3.2 生成int8 umodel

在命令行中执行`convert_squeezenet_to_int8`生成squeezenet\_21k.int8umodel，运行过程需要一段时间（可能10分钟，视您主机的配置而定），请耐心等待：

```
......

I1206 10:45:26.728435   300 cali_core.cpp:1941]
I1206 10:45:26.728439   300 cali_core.cpp:1942] calibration for layer = m1@ssh_cls_prob_reshape
I1206 10:45:26.728442   300 cali_core.cpp:1943]  id=132 type:Reshape ...
I1206 10:45:26.728447   300 quantize_layerwise.cpp:257]  intput 0 is float =1
I1206 10:45:26.728451   300 cali_core.cpp:2072]  intput 0: set_scaleconvertbacktofloat_input_mul =0.00787209
I1206 10:45:26.728456   300 cali_core.cpp:2076]  output 0 set_scaleconvertbacktofloat_output_mul =0.00787209
I1206 10:45:26.728459   300 cali_core.cpp:2079]  forward_with_float = 1
I1206 10:45:26.728462   300 cali_core.cpp:2080]  output_is_float = 1
I1206 10:45:26.728466   300 cali_core.cpp:2081]  is_shape_layer  = 0
I1206 10:45:26.728469   300 cali_core.cpp:2082]  use_max_as_th =0

I1206 10:45:27.767645   300 cali_core.cpp:2268] used time=0 hour:1 min:48 sec
I1206 10:45:27.767688   300 cali_core.cpp:2270] int8 calibration done.
```

### 3.4.3.3 使用int8 umodel进行人脸检测

执行`detect_squeezenet_int8`使用squeezenet\_21k.int8umodel检测人脸：

```
# 以下为命令行输出
/workspace/examples/calibration/face_demo
rm -f *.o *.so *.a
rm -rf bin/ obj/
rm -rf models/squeezenet/*test_*
mkdir -p bin/ obj/ obj/examples/
......
WARNING: Logging before InitGoogleLogging() is written to STDERR
I1206 12:05:18.652485   942 net_cfg.cpp:123] id<0> Creating Layer data type=Input
I1206 12:05:18.652595   942 net.cpp:994] data -> data
I1206 12:05:18.652645   942 net_cfg.cpp:123] id<1> Creating Layer conv1 type=Convolution
......
final predict 19 bboxes
......
x1=484.152
y1=201.54
w=55.7996
h=63.2861

(detection.png:942): Gtk-WARNING **: cannot open display:
```

执行完毕，使用int8 umodel最终检测出19个目标框，可以查看生成的图片(当前目录detection\_int8.png)确认。

{% hint style="warning" %}
**补充说明：**

最后的Gtk-WARNING是由于程序在最后使用OpenCV imshow()函数创建窗口显示图片，而默认在容器内无法使用显示设备，可以忽略。

若您需要在docker容器内显示图像，需要确保以下几点：

* 一台安装了显示器的主机A（192.168.150.100）用于显示画面
* docker容器所在的宿主机B跟主机A网络连通（A、B可以是同一台主机）
* 主机A上安装了X11 Server且已正确配置，允许客户端通过tcp传输待显示画面
* 在docker容器内正确设置了DSIPLAY环境变量：export DISPLAY= 192.168.150.100:0.0

关于X11 Server的安装、配置方法以及其他更多实现细节，请自行查阅资料。
{% endhint %}

`detect_squeezenet_int8`该命令每次执行都会先执行程序的clean和build，若您已经执行过1次，程序已经编译生成，您可以在命令行中直接执行程序：

```bash
./bin/demo_detect \
   models/squeezenet/squeezenet_21k_deploy_int8_unique_top.prototxt \
   models/squeezenet/squeezenet_21k.int8umodel \
   0.7 sample/test_2.jpg
```

### 3.4.3.4 其他测试

您也可以执行`face_demo.sh`中的其他命令，如`detect_squeezenet_fp32`测试fp32 umodel的检测结果，并与int8 umodel的结果比对。

```bash
# 若您已经按照3.4.3.1指示执行过source face_demo.sh则可在命令行直接执行
detect_squeezenet_fp32
```

执行后，终端将输出以下信息：

```bash
...
I1209 23:20:38.093816  3446 net_cfg.cpp:39] Top shape:  [1 4 49 88] (17248)
I1209 23:20:38.093822  3446 net_cfg.cpp:42] Memory required for data: 68992 Dtype width:4
final predict 19 bboxes
x1=1482.59
y1=243.254
w=66.2257
h=78.7983
x1=1353.07
y1=203.064
w=65.2163
h=84.9517
...
```

可见使用fp32 umodel最终也检测出19个目标框，可以查看生成的图片(当前目录detection.png)确认，并与int8 umodel的结果（当前目录detection\_int8.png）比较。
