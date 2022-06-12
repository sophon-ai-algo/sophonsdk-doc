# 3.2.6 编译ONNX模型

BMNETO 是针对 ONNX 的模型编译器，可以把 ONNX 格式的 model 经过图编译优化后，转换成 BMRuntime 所需的文件。在编译模型的同时，可选择将每一个操作的 NPU 模型计算结果和 CPU 的计算结果进行对比， 保证正确性。

* 命令行形式：

```bash
python3 -m bmneto [--model=<path>] \ 
                  [--input_names=<string>] \ 
                  [--shapes=<string>] \ 
                  [--outdir=<path>] \ 
                  [--target=<name>] \ 
                  [--net_name=<name>] \ 
                  [--opt=<value>] \ 
                  [--dyn=<bool>] \ 
                  [--cmp=<bool>] \ 
                  [--mode=<string>] \ 
                  [--descs=<string>] \ 
                  [--enable_profile=<bool>] \ 
                  [--output_names=<string>] \ 
                  [--list_ops]
```

参数介绍：

| args            | type   | Description                                                                                                                                                                                                                                                                                                                                                                                           |
| --------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model           | string | **Necessary.**ONNX model (.onnx) path                                                                                                                                                                                                                                                                                                                                                                 |
| input\_names    | string | **Optional.**Set name of all network inputs one by one in sequence. Format “name1,name2,name3”                                                                                                                                                                                                                                                                                                        |
| shapes          | string | **Necessary.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence                                                                                                                                                                                                                                              |
| outdir          | string | **Necessary.** Output directory                                                                                                                                                                                                                                                                                                                                                                       |
| target          | string | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                                                                                                                                                                                                                                                                |
| net\_name       | string | **Optional.** Name of the network, default use the name in onnx path                                                                                                                                                                                                                                                                                                                                  |
| opt             | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 1.                                                                                                                                                                                                                                                                                                                                         |
| dyn             | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                                                                                                                                                                                                                                                                 |
| cmp             | bool   | **Optional.**Check result during compilation. Default: true                                                                                                                                                                                                                                                                                                                                           |
| mode            | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                                                                                                                                                                                                                                                                          |
| descs           | string | **Optional.** Describe data type and value range of some input in format: "\[ index, data format, lower bound, upper bound ]", where data format could be fp32, int64. For example, "\[0, int64, 0, 100]", meaning input of index 0 has data type as int64 and values in \[0, 100). If no description of some input given, the data type will be fp32 as default and uniformly distributed in 0 \~ 1. |
| enable\_profile | bool   | **Optional.** Enable profile log. Default: false                                                                                                                                                                                                                                                                                                                                                      |
| output\_names   | string | **Optional.** Set name of all network outputs one by one in sequence. Format "name1,name2,name2"                                                                                                                                                                                                                                                                                                      |
| list\_ops       |        | **Optional.** List supported ops.                                                                                                                                                                                                                                                                                                                                                                     |

* Python模式：

```python
import bmneto
## compile fp32 model
bmneto.compile(
    model = "/path/to/.pth", ## Necessary
    outdir = "xxx", ## Necessary
    target = "BM1684", ## Necessary
    shapes = [[x,x,x,x], [x,x,x]], ## Necessary
    net_name = "name", ## Necessary
    input_names = ['name0','name1'] ## Necessary
    opt = 2, ## optional, if not set, default equal to 1
    dyn = False, ## optional, if not set, default equal to False
    cmp = True, ## optional, if not set, default equal to True
    enable_profile = True ## optional, if not set, default equal to False
    descs = [[0, int, 0, 128]] ## optional, if not set, default equal to [[x, float, 0,
,→ 1]]
    output_names = ['oname0','oname1'] ## optional, if not set, default equal to graph␣ ,→output names
)
```

bmneto若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmneto成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。
