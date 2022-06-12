# 3.2.2 编译TensorFlow模型

BMNETT是针对tensorflow的模型编译器，可以将模型文件 (\*.pb）编译成 BMRuntime 所需的文件。而且在编译的同时，可选择将每一个操作的 NPU 模型计算结果和 CPU 的计算结果进行对比，保证正确性。

bmnett的使用例程参见${BMNNSDK}/examples/nntc/bmnett。

* 命令行形式：

```
python3 -m bmnett [--model=<path>] \
                  [--input_names=<string>] \ 
                  [--shapes=<string>] \ 
                  [--descs=<string>] \ 
                  [--output_names=<string>] \ 
                  [--net_name=<name>] \ 
                  [--opt=<value>] \ 
                  [--dyn=<bool>] \ 
                  [--outdir=<path>] \ 
                  [--target=<name>] \ 
                  [--cmp=<bool>] \ 
                  [--mode=<string>] \ 
                  [--enable_profile=<bool>] \ 
                  [--list_ops]
```

| args            | type   | Description                                                                                                                                                    |
| --------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model           | string | **Necessary.** TensorFlow .pb file path                                                                                                                        |
| input\_names    | string | **Necessary.** Set name of all network inputs one by one in sequence. Format “name1,name2,name3”                                                               |
| shapes          | string | **Necessary.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence       |
| descs           | string | **Optional.** Descriptions of inputs, format "\[serial number, data type, lower bound, upper bound]", e.g., "\[0, uint8, 0, 256]", default "\[x, float, 0, 1]" |
| output\_names   | string | **Necessary.** Set name of all network outputs one by one in sequence. Format “name1,name2,name2”                                                              |
| net\_name       | string | **Necessary.** Name of the network.                                                                                                                            |
| opt             | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 2.                                                                                                  |
| dyn             | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                          |
| outdir          | string | **Necessary.** Output directory                                                                                                                                |
| target          | string | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                         |
| cmp             | bool   | **Optional.**Check result during compilation. Default: true                                                                                                    |
| mode            | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                                   |
| enable\_profile | bool   | **Optional.** Enable profile log. Default: false                                                                                                               |
| list\_ops       |        | **Optional.** List supported ops.                                                                                                                              |

* Python形式：

```python
import bmnett
## compile fp32 model
bmnett.compile(
    model = "/path/to/model(.pb)",     ## Necessary
    outdir = "xxx",                    ## Necessary
    target = "BM1684"，                ## Necessary
    shapes = [[x,x,x,x], [x,x,x]],     ## Necessary
    net_name = "name",                 ## Necessary
    input_names=["name1", "name2"],    ## Necessary, when .h5 use None
    output_names=["out_name1", "out_name2"], ## Necessary, when .h5 use None
    opt = 2,                           ## optional, if not set, default equal to 1
    dyn = False,                       ## optional, if not set, default equal to False
    cmp = True,                        ## optional, if not set, default equal to True
    enable_profile = True              ## optional, if not set, default equal to False
)
```

bmnett若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnett成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。 &#x20;
