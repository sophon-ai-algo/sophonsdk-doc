# 3.2 FP32 模型生成

​基于SophonSDK提供的BMNet工具链可以很方便地将原始第三方深度学习框架下训练的模型转换为BModel。

| 编译器      | 功能                              | 使用指导                                                                                          |
| -------- | ------------------------------- | --------------------------------------------------------------------------------------------- |
| bmnetc   | 编译Caffe模型                       | [BMNETC使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetc.html)     |
| bmnett   | 编译TensorFlow模型                  | [BMNETT使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnett.html)     |
| bmnetm   | 编译MXNet模型                       | [BMNETM使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetm.html)     |
| bmnetp   | 编译PyTorch模型                     | [ BMNETP使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetp.html)    |
| bmnetd   | 编译Darknet模型                     | [BMNETD使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetd.html)     |
| bmnetu   | 编译算丰自定义UFW(Unified Framework)模型 | [BMNETU使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetu.html)     |
| bmneto   | 编译ONNX模型                        | [BMNETO使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmneto.html)     |
| bmpaddle | 编译PaddlePaddle模型                | [BMPADDLE使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmpaddle.html) |

执行`source envsetup_xxx.sh`会自动安装以上转换工具，并在当前终端设置相关的环境变量。您也可以将环境变量写到配置文件`~/.bashrc`中。

{% hint style="warning" %}
**注意：**

对于有些模型，比如paddle-ocr-detection或其他算子中有很多累加或除法的模型，如果在转换过程中打开比对选项的话，会由于误差累计而导致比对结果超出允许的误差阈值范围，模型转换中断；还有一些有排序操作的模型，虽然误差不大，但会影响排序的顺序，从而导致比对出错、转换中断。对于这些情况，可以在转换过程中关闭cmp参数，不进行数据比对，待模型转换完成后再到业务层面验证转换后模型的精度。
{% endhint %}

{% hint style="info" %}
**PyTorch模型转换注意事项**

1. 什么是JIT（torch.jit）：JIT（Just-In-Time）是一组编译工具，用于弥合PyTorch研究与生产之间的差距。它允许创建可以在不依赖Python解释器的情况下运行的模型，并且可以更积极地进行优化。
2. JIT与BMNETP的关系：BMNETP只接受PyTorch的JIT模型。
3. 如何得到JIT模型：在已有PyTorch的Python模型（基类为torch.nn.Module）的情况下，通过torch.jit.trace得到 torch.jit.trace(python\_model,torch.rand(input\_shape)).save('jit\_model')
4. 为什么不能使用torch.jit.script得到JIT模型：BMNETP暂时不支持带有控制流操作（如if语句或循环）、inplace的操作（如copy\_函数等）的JIT模型，但torch.jit.script可以产生这类模型，而torch.jit.trace却不可以，仅跟踪和记录张量上的操作，不会记录任何控制流操作。
5. 为什么不能是GPU模型：BMNETP的编译过程不支持。
6. 如何将GPU模型转成CPU模型？ 在加载PyTorch的Python模型时，使用map\_location参数 torch.load(python\_model, map\_location = 'cpu')

**Darknet模型转换注意事项**

cfg 文件中batch/subvision 要大于转换脚本中设置的输入shape的batch size。&#x20;
{% endhint %}

