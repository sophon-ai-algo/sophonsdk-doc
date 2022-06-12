# 3.2.5 编译 Darknet 模型

BMNETD 是针对 Darknet 的模型编译器，可将某网络的 weight 和 cfg 编译成 BMRuntime 所需要 的文件 (目前只支持 yolo)。而且在编译的同时，支持每一层的 NPU 模型计算结果都会和 CPU 的计算结果进行对 比，保证正确性。

bmnetd的使用例程参见${BMNNSDK}/examples/nntc/bmnetd。

{% hint style="info" %}
**Darknet模型转换注意事项**

cfg 文件中batch/subvision 要大于转换脚本中设置的输入shape的batch size。&#x20;
{% endhint %}

* 命令行形式：

```bash
/path/to/bmnetd [--model=<path>] \
                [--weight=<path>] \
                [--shapes=<string>] \ 
                [--net_name=<name>] \ 
                [--opt=<value>] \ 
                [--dyn=<bool>] \ 
                [--outdir=<path>] \ 
                [--target=<name>] \ 
                [--cmp=<bool>] \ 
                [--mode=<string>] \ 
                [--enable_profile=<bool>]
```

参数介绍：

| args            | type   | Description                                                                                                                                             |
| --------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model           | string | **Necessary.** Darknet cfg path                                                                                                                         |
| weights         | string | **Necessary.**Darknet weight path                                                                                                                       |
| shapes          | string | **Optional.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence |
| net\_name       | string | **Optional.** Name of the network, default use cfg path                                                                                                 |
| opt             | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 2.                                                                                           |
| dyn             | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                   |
| outdir          | string | **Necessary.** Output directory                                                                                                                         |
| target          | string | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                  |
| cmp             | bool   | **Optional.**Check result during compilation. Default: true                                                                                             |
| mode            | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                            |
| enable\_profile | bool   | **Optional.** Enable profile log. Default: fals                                                                                                         |
| log\_dir        | string | **Optional.** Specify the log directory Default: “”                                                                                                     |
| v               | string | **Optional.**Set log verbose level. Default: 0 (0: FATAL, 1: ERROR, 2: WARNING, 3: INFO, 4: DEBUG).                                                     |
| dump\_ref       | bool   | **Optional.**Enable dump input\&output ref data when compile without compare. Default: false.                                                          |

* Python模式：

```python
import bmnetd
## compile fp32 model
bmnetd.compile(
    model = "/path/to/cfg", ## Necessary
    weight = "/path/to/weight", ## Necessary
    outdir = "xxx", ## Necessary
    target = "BM1684", ## Necessary
    net_name = "name", ## optional, if not set, default use the path of cfg
    shapes = [[x,x,x,x], [x,x,x]], ## optional, if not set, default use shape in weights
    opt = 2, ## optional, if not set, default equal to 2
    dyn = False, ## optional, if not set, default equal to False
    cmp = True, ## optional, if not set, default equal to True
    enable_profile = False ## optional, if not set, default equal to False
)
```

bmnetd若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnetd成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。
