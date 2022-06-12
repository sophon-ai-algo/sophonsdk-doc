# 3.2.1 编译Caffe模型

BMNETC是针对Caffe的模型编译器，可将某网络的caffemodel和prototxt编译成BMRuntime所需要的文件。而且在编译的同时，支持将每一层的NPU模型计算结果与CPU的计算结果进行比对，保证正确性。

bmnetc的使用例程参见${BMNNSDK}/examples/nntc/bmnetc。

* 命令行形式：&#x20;

```bash
/path/to/bmnetc [--model=<path>] \
                [--weight=<path>] \
                [--shapes=<string>] \
                [--net_name=<name>] \
                [--opt=<value>] \
                [--dyn=<bool>] \
                [--outdir=<path>] \
                [--target=<name>] \
                [--cmp=<bool>] \
                [--mode=<string>] \
                [--enable_profile=<bool>] \
                [--show_args] \
                [--list_ops]
```

| **args**        | **type** | **Description**                                                                                                                                         |
| --------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model           | string   | **Necessary.** Caffe prototxt path                                                                                                                      |
| weight          | string   | **Necessary.** caffemodel(weight) path                                                                                                                  |
| shapes          | string   | **Optional.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence |
| net\_name       | string   | **Optional.** Name of the network, default use the name in prototxt                                                                                     |
| opt             | int      | **Optional.** Optimization level. Option: 0, 1, 2, default 2.                                                                                           |
| dyn             | bool     | **Optional.** Use dynamic compilation, default false.                                                                                                   |
| outdir          | string   | **Necessary.** Output directory                                                                                                                         |
| target          | string   | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                  |
| cmp             | bool     | **Optional.**Check result during compilation. Default: true                                                                                             |
| mode            | string   | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                            |
| enable\_profile | bool     | **Optional.** Enable profile log. Default: false                                                                                                        |
| show\_args      |          | **Optional.** Display arguments passed to bmnetc compiler.                                                                                              |
| list\_ops       |          | **Optional.** List bmnetc supported ops.                                                                                                                |

以sdk中的SSD模型编译float32 bmodel为例，先执行`cd /workspace/examples/SSD_object/model/`进入SSD模型示例，若该目录下不存在SSD模型文件，则运行：

```
./download_ssd_model.sh
```

{% hint style="info" %}
如果客户主机网络不能访问google，可以手动下载文件后放在model目录下，

下载链接https://pan.baidu.com/s/1DZfQerGuLjup04A8DAco7w 提取码: tuk1
{% endhint %}

脚本`gen_bmodel.sh`中的主要内容如下：

```bash
bmnetc --model=${model_dir}/ssd300_deploy.prototxt \
       --weight=${model_dir}/ssd300.caffemodel \
       --shapes=[1,3,300,300] \
       --outdir=./out/ssd300 \
       --target=BM1684
```

{% hint style="info" %}
* 转换模型过程中会在指定的文件夹中生成一个input\_ref\_data.dat和一个output\_ref\_data.dat，分别是网络输入参考数据和网络输出参考数据，可用于bmrt\_test验证生成的bmodel在芯片运行时结果是否正确。
* 执行成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件就是转换成功的bmodel，用户可以重命名。
* 若用户在使用bmnetc命令时设置了cmp=true模式，则在转换过程最后会直接利用生成的验证数据进行验证并提示验证结果是否正确。
{% endhint %}

执行完脚本后正常的输出结果如下：

```
============================================================
*** Store bmodel of BMCompiler...
============================================================
I1124 23:35:48.233935   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor input name [data]
I1124 23:35:48.233953   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor output name [detection_out]
I1124 23:35:48.759522   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor input name [data]
I1124 23:35:48.759550   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor output name [mbox_loc]
I1124 23:35:48.759555   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor output name [mbox_priorbox]
I1124 23:35:48.759558   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor output name [mbox_conf_flatten]
I1124 23:35:48.759822   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor input name [mbox_loc]
I1124 23:35:48.759831   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor input name [mbox_conf_flatten]
I1124 23:35:48.759836   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor input name [mbox_priorbox]
I1124 23:35:48.759842   852 bmcompiler_bmodel.cpp:130] [BMCompiler:I] save_tensor output name [detection_out]
BMLIB Send Quit Message
Success: combined to [out/fp32_ssd300.bmodel].
```

编译生成的模型存放在如下目录：

```
out/
├── fp32_ssd300.bmodel     //f32_1b.bmodel 和 f32_4b.bmodel 进行combine后的bmodel
├── ssd300
│   ├── compilation.bmodel
│   ├── f32_1b.bmodel
│   ├── input_ref_data.dat
│   ├── io_info.dat
│   └── output_ref_data.dat
└── ssd300_4batch
    ├── compilation.bmodel
    ├── f32_4b.bmodel
    ├── input_ref_data.dat
    ├── io_info.dat
    └── output_ref_data.dat
```

至此生成bmodel。执行如下命令，检测模型的精度回归：

```
cd /workspace/examples/SSD_object/model
bmrt_test --context_dir=./out/ssd300
```

正常结束后提示如下：

```
[BMRT][deal_with_options:1378] INFO:Loop num: 1
bmcpu init: skip cpu_user_defined
open usercpu.so, init user_cpu_init
[BMRT][load_bmodel:823] INFO:Loading bmodel from [./out/ssd300/compilation.bmodel]. Thanks for your patience...
[BMRT][load_bmodel:787] INFO:pre net num: 0, load net num: 1
[BMRT][bmrt_test:705] INFO:==> running network #0, name: VGG_VOC0712_SSD_300x300_deploy, loop: 0
[BMRT][bmrt_test:981] INFO:net[VGG_VOC0712_SSD_300x300_deploy] stage[0], launch total time is 34126 us (npu 33602 us, cpu 524 us)
[BMRT][bmrt_test:984] INFO:+++ The network[VGG_VOC0712_SSD_300x300_deploy] stage[0] output_data +++
[BMRT][print_array:647] INFO:output data #0 shape: [1 1 1 7 ] < 0 -1 -1 -1 -1 -1 -1 >
[BMRT][bmrt_test:1004] INFO:==>comparing #0 output ...
[BMRT][bmrt_test:1009] INFO:+++ The network[VGG_VOC0712_SSD_300x300_deploy] stage[0] cmp success +++
[BMRT][bmrt_test:1029] INFO:load input time(s): 0.001130
[BMRT][bmrt_test:1030] INFO:calculate  time(s): 0.034130
[BMRT][bmrt_test:1031] INFO:get output time(s): 0.000060
[BMRT][bmrt_test:1032] INFO:compare    time(s): 0.000160
```

当有“+++ The network\[VGG\_VOC0712\_SSD\_300x300\_deploy] stage\[0] cmp success +++”的提示，则模型编译流程正确，与原生模型的精度一致。

* python形式：

```python
import bmnetc

## compile fp32 model

bmnetc.compile(
  model = "/path/to/prototxt",    ## Necessary
  weight = "/path/to/caffemodel", ## Necessary
  outdir = "xxx",                 ## Necessary
  target = "BM1684",              ## Necessary
  shapes = [[x,x,x,x], [x,x,x]],  ## optional, if not set, default use shape in prototxt
  net_name = "name",              ## optional, if not set, default use the network name in prototxt
  opt = 2,                        ## optional, if not set, default equal to 2
  dyn = False,                    ## optional, if not set, default equal to False
  cmp = True,                     ## optional, if not set, default equal to True
  enable_profile = False          ## optional, if not set, default equal to False
)
```

bmnetc若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnetc成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。
