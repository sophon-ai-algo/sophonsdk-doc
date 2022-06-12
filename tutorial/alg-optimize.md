# 2.3 跑通第一个例子：算法迁移

算法迁移部分主要的工作是使用BM1684提供的软件接口，实现原来有caffe/pytorch等框架实现的前后处理、推理等代码。具体接口细节可以参考${BMNNSDK}/examples/SSD\__object/cpp\_cv\_bmcv\_bmrt_中提供的具体的代码。

下面介绍一下编译方法，此例子支持PCIE模式和SOC模式。

### 2.3.1 程序编译

进入examples/SSD\_object/cpp\_cv\_bmcv\_bmrt目录，执行make命令编译程序：

```bash
# 当前所在目录
cd /workspace/examples/SSD_object/cpp_cv_bmcv_bmrt
make -f Makefile.pcie # for PCIE MODE
make -f Makefile.arm  # for SoC MODE
```

&#x20;编译完成后，会生成ssd300\__cv\__bmcv\_bmrt.pcie或者ssd300\__cv\__bmcv\_bmrt.arm，支持图片检测或者视频检测，具体参数说明如下：

{% hint style="info" %}
```
# 程序参数说明:
# ./ssd300_cv_bmcv_bmrt.xxx image <image file> <bmodel path> <test count> <device id>
# ./ssd300_cv_bmcv_bmrt.xxx video <video url>  <bmodel path> <test count> <device id>
```
{% endhint %}

### 2.3.2 PCIE模式下运行

直接在docker容器终端内执行即可：

```bash
# 使用图片测试
# ./ssd300_cv_bmcv_bmrt.xxx image <image file> <bmodel path> <test count> <device id>
./ssd300_cv_bmcv_bmrt.pcie image /workspace/res/image/vehicle_1.jpg \
  ../model/out/fp32_ssd300.bmodel 1 0
```

运行后，会在当前目录创建results文件夹保存检测结果。

```
# 终端输出
...
set device id:0
bmcpu init: skip cpu_user_defined
open usercpu.so, init user_cpu_init
[BMRT][load_bmodel:823] INFO:Loading bmodel from [../model/out/fp32_ssd300.bmodel]. Thanks for your patience...
[BMRT][load_bmodel:787] INFO:pre net num: 0, load net num: 1
Open /dev/bm-sophon0 successfully, device index = 0, jpu fd = 27, vpp fd = 27
class id:  6 upper-left: ( 652.67542,  253.06639)  object-size: ( 945.39197,  676.06012)
class id:  6 upper-left: (1376.94324,  438.03113)  object-size: ( 521.96301,  643.66248)
class id:  6 upper-left: ( 832.24683,   49.16213)  object-size: ( 345.22144,  162.27859)
class id:  7 upper-left: ( 236.51318,  802.92780)  object-size: ( 486.17816,  269.36493)
class id:  7 upper-left: (1282.00513,  209.12936)  object-size: ( 202.10974,  115.12851)
class id:  7 upper-left: ( 372.09344,  535.28412)  object-size: ( 309.26434,  229.60358)
class id:  7 upper-left: ( 502.21912,  130.76361)  object-size: ( 141.95667,  148.55127)
class id:  7 upper-left: (1552.48718,  262.08255)  object-size: ( 273.29871,  141.04590)
class id:  7 upper-left: (1101.15466,  173.13582)  object-size: ( 152.95129,   96.85536)
##############################################

############################
SUMMARY: detect
############################
[         ssd overall]  loops:    1 avg: 54431 us
[          read image]  loops:    1 avg: 9746 us
[        attach input]  loops:    1 avg: 3 us
[           detection]  loops:    1 avg: 35894 us
[     ssd pre-process]  loops:    1 avg: 1367 us
[ ssd pre-process-vpp]  loops:    1 avg: 1201 us
[ssd pre-process-linear_tranform]  loops:    1 avg: 163 us
[       ssd inference]  loops:    1 avg: 34220 us
[    ssd post-process]  loops:    1 avg: 302 us
...

# results目录内容
# log.txt  out-batch-fp32-t_0_vehicle_1.jpg
```

### 2.3.3 SOC模式下运行

将生成的ssd300\_cv\_bmcv\_bmrt.arm文件，以及bmodel文件和测试图片文件，均拷贝到SE5小盒子上/data目录下，然后再运行（需要配置好环境变量，参考[on-soc.md](../bmnnsdk2/setup/on-soc.md "mention")）。

输出内容和PCIE的内容类似，此处不再详述。

