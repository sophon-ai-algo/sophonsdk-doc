# 3.2.4 编译PyTorch模型

BMNETP是针对PyTorch的模型编译器，可以把PyTorch的model直接编译成BMRuntime所需的执行指令。pytorch 的模型在编译前要经过 torch.jit.trace（见 PyTorch官方文档），trace 后的模型才能用于编译。在编译模型的同时，可选择将每一个操作的 NPU 模型计算结果和 CPU 的计算结果进行对比， 保证正确性。

bmnetp的使用例程参见${BMNNSDK}/examples/nntc/bmnetp。

{% hint style="info" %}
**PyTorch模型转换注意事项**

1. 什么是JIT（torch.jit）：JIT（Just-In-Time）是一组编译工具，用于弥合PyTorch研究与生产之间的差距。它允许创建可以在不依赖Python解释器的情况下运行的模型，并且可以更积极地进行优化。
2. JIT与BMNETP的关系：BMNETP只接受PyTorch的JIT模型。
3. 如何得到JIT模型：在已有PyTorch的Python模型（基类为torch.nn.Module）的情况下，通过torch.jit.trace得到 torch.jit.trace(python\_model,torch.rand(input\_shape)).save('jit\_model')
4. 为什么不能使用torch.jit.script得到JIT模型：BMNETP暂时不支持带有控制流操作（如if语句或循环）、inplace的操作（如copy\_函数等）的JIT模型，但torch.jit.script可以产生这类模型，而torch.jit.trace却不可以，仅跟踪和记录张量上的操作，不会记录任何控制流操作。
5. 为什么不能是GPU模型：BMNETP的编译过程不支持。
6. 如何将GPU模型转成CPU模型？ 在加载PyTorch的Python模型时，使用map\_location参数 torch.load(python\_model, map\_location = 'cpu')
{% endhint %}

* bmnetp安装：

```
cd /workspace/bmnet/bmnetp/
pip3 install bmnetp-x.x.x-py2.py3-none-any.whl # <x.x.x>为对应SDK版本
```

* 命令行形式：

```bash
python3 -m bmnetp [--model=<path>] \
                  [--shapes=<string>] \
                  [--net_name=<name>] \
                  [--opt=<value>] \
                  [--dyn=<bool>] \
                  [--outdir=<path>] \
                  [--target=<name>] \
                  [--cmp=<bool>] \
                  [--enable_profile=<bool>] \
                  [--list_ops]
```

参数介绍：

| args            | type   | Description                                                                                                                                              |
| --------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| model           | string | **Necessary.** Traced PyTorch model (.pt) path                                                                                                           |
| shapes          | string | **Necessary.** Shapes of all inputs, default use the shape in prototxt, format \[\[x,x,x,x],\[x,x],…], these correspond to inputs one by one in sequence |
| net\_name       | string | **Necessary.** Name of the network.                                                                                                                      |
| opt             | int    | **Optional.** Optimization level. Option: 0, 1, 2, default 1.                                                                                            |
| dyn             | bool   | **Optional.** Use dynamic compilation, default false.                                                                                                    |
| outdir          | string | **Necessary.** Output directory                                                                                                                          |
| target          | string | **Necessary.** Option: BM1682, BM1684; default: BM1682                                                                                                   |
| cmp             | bool   | **Optional.**Check result during compilation. Default: true                                                                                              |
| mode            | string | **Optional.** Set bmnetc mode. Option: compile, GenUmodel. Default: compile.                                                                             |
| enable\_profile | bool   | **Optional.** Enable profile log. Default: false                                                                                                         |
| list\_ops       |        | **Optional.** List supported ops.                                                                                                                        |

* Python模式：

```python
import bmnetp
## compile fp32 model
bmnetp.compile(
　　  model = "/path/to/.pth",        ## Necessary
　　  outdir = "xxx",                 ## Necessary
　　  target = "BM1684",              ## Necessary
　　  shapes = [[x,x,x,x], [x,x,x]],  ## Necessary
　　  net_name = "name",              ## Necessary
　　  opt = 2,                        ## optional, if not set, default equal to 1
　　  dyn = False,                    ## optional, if not set, default equal to False
　　  cmp = True,                     ## optional, if not set, default equal to True
　　  enable_profile = True           ## optional, if not set, default equal to False
)
```

bmnetp若成功，输出的 log 最后会看到以下信息：

```bash
######################################
# Store bmodel of BMCompiler.
######################################
```

bmnetp成功后，将在指定的文件夹中生成一个compilation.bmodel的文件，该文件则是转换成功的 bmodel，用户可以重命名。
