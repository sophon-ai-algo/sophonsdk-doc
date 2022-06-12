# 3.3.5 生成INT8 Bmodel

int8umodel作为一个临时中间存在形式，需要进一步转换为可以在算能AI平台执行的int8 bmodel，本节可以看作是int8 umodel的部署操作或者int8 bmodel的生成操作。

通过使用SDK提供的BMNETU工具，可以将3.3.3节的输出int8 umodel（如下）作为输入，方便快捷地转换为int8 bmodel。

```
**.int8umodel,
**_deploy_int8_unique_top.prototxt
```

BMNETU是针对BM1684的UFW(Unified Framework)模型编译器，可将某网络的umodel(Unified Model)和 prototxt编译成BMRuntime所需要的文件。而且在编译的同时，支持每一层的NPU模型计算结果和CPU的计算结果进行对比，保证正确性。

* **命令行方式：**

```
/path/to/bmnetu -model=<path> \
　　              -weight=<path> \
　　              -shapes=<string> \
　　              -net_name=<name> \
　　              -opt=<value> \
　　              -dyn=<bool> \
　　              -prec=<string> \
　　              -outdir=<path> \
　　              -cmp=<bool> \
　　              -mode=<string>
```

参数介绍：

| args      | type   | Description                                                                                                                                                                                                                                           |
| --------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model     | string | **Necessary.** UFW prototxt path                                                                                                                                                                                                                      |
| weight    | string | **Necessary.** Umodel(weight) path                                                                                                                                                                                                                    |
| shapes    | string | **Optional.** Shapes of all inputs, default use the shape in prototxt, format \[x,x,x,x],\[x,x]…, these correspond to inputs one by one in sequence                                                                                                   |
| net\_name | string | **Optional.** Name of the network, default use the name in prototxt                                                                                                                                                                                   |
| opt       | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 1.                                                                                                                                                                                         |
| dyn       | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                                                                                                                 |
| outdir    | string | **Necessary.** Output directory                                                                                                                                                                                                                       |
| prec      | string | **Optional.** Data type of Umodel. Option: FP32, INT8. default FP32.                                                                                                                                                                                  |
| cmp       | bool   | **Optional.**Check result during compilation. Default: true                                                                                                                                                                                           |
| mode      | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                                                                                                                          |
| use\_wino | bool   | **Optional.** Use winograd convolution. If not given, the flag value will be determined by model files. Note that it’s a global flag for all conv layers, and it can be overridden by the layer-level flag use\_winograd (which is false by default). |

* Python接口：

```python
import bmnetu
## compile int8 model
bmnetu.compile(
    model = "/path/to/prototxt", ## Necessary
    weight = "/path/to/caffemodel", ## Necessary
    outdir = "xxx", ## Necessary
    prec = "INT8", ## optional, if not set, default use FP32
    shapes = [[x,x,x,x], [x,x,x]], ## optional, if not set, default use shape in prototxt
    net_name = "name", ## optional, if not set, default use the network name␣ ,→in prototxt
    opt = 2, ## optional, if not set, default equal to 2
    dyn = False, ## optional, if not set, default equal to False
    cmp = True ## optional, if not set, default equal to True
)
```

bmnetu 若执行成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnetu 执行成功后，将在指定的文件夹中生成一个 compilation.bmodel 的文件，该文件则是转换成功 的 bmodel，用户可以重命名。
