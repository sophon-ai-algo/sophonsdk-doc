# 3.2.3 编译MXNet模型

BMNETM是针对MXNet的模型编译器，可以将MXNet格式的模型结构文件和参数文件（比如：lenet-symbol.json和lenet-0100.params）经过图编译优化后，转换成BMRuntime所需的文件。可选择将每一个操作的NPU模型计算结果和原始模型在mxnet框架上的计算结果进行对比，保证模型转换的正确性。

bmnetm的使用例程参见${BMNNSDK}/examples/nntc/bmnetm。

* bmnetm安装：

```
cd /workspace/bmnet/bmnetm/
pip3 install bmnetm-x.x.x-py2.py3-none-any.whl # <x.x.x>为对应SDK版本
```

*   命令行形式：

    ```
    python3 -m bmnetm [--model=<path>] \
                      [--weight=<path>] \
                      [--shapes=<string>] \
                      [--input_names=<string>] \
                      [--net_name=<name>] \
                      [--opt=<value>] \
                      [--dyn=<bool>] \
                      [--outdir=<path>] \
                      [--target=<name>] \
                      [--cmp=<bool>] \
                      [--enable_profile=<bool>] \
                      [--list_ops]
    ```

    参数介绍如下：

    | args            | type   | Description                                                                                                                                              |
    | --------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | model           | string | **Necessary.** MxNet symbol .json path                                                                                                                   |
    | weight          | string | **Necessary.** MxNet weight .params path                                                                                                                 |
    | shapes          | string | **Necessary.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence |
    | input\_names    | string | **Optional.** Set input name according to .json. They correspond to shapes one by one. Default: “data”. Format “name1,name2,…”.                          |
    | net\_name       | string | **Necessary.**Name of the network, default use the name in prototxt                                                                                      |
    | opt             | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 1.                                                                                            |
    | dyn             | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                    |
    | outdir          | string | **Necessary.** Output directory                                                                                                                          |
    | target          | string | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                   |
    | cmp             | bool   | **Optional.**Check result during compilation. Default: true                                                                                              |
    | mode            | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                             |
    | enable\_profile | bool   | **Optional.** Enable profile log. Default: false                                                                                                         |
    | list\_ops       |        | **Optional.** List supported ops.                                                                                                                        |
* Python形式：

```python
import bmnetm
## compile fp32 model
bmnetm.compile(
　　  model = "/path/to/.json",       ## Necessary
　　  weight = "/path/to/.params",    ## Necessary
　　  outdir = "xxx",                 ## Necessary
　　  target = "BM1684",              ## Necessary
　　  shapes = [[x,x,x,x], [x,x,x]],  ## Necessary
　　  net_name = "name",              ## Necessary
　　  input_names=["name1","name2"]   ## optional, if not set, default is "data"
　　  opt = 2,                        ## optional, if not set, default equal to 1
　　  dyn = False,                    ## optional, if not set, default equal to False
　　  cmp = True,                     ## optional, if not set, default equal to True
　　  enable_profile = True           ## optional, if not set, default equal to False
)
```

bmnetm若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnetm成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。
