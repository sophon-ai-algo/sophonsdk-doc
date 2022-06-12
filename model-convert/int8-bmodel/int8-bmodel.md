# 3.3.5 生成INT8 Bmodel

int8umodel作为一个临时中间存在形式，需要进一步转换为可以在Sophon AI平台执行的int8 bmodel，本节可以看作是int8 umodel的部署操作或者int8 bmodel的生成操作。

通过使用SDK提供的BMNETU工具，可以将3.3.3节的输出int8 umodel（如下）作为输入，方便快捷地转换为int8 bmodel。

```
**.int8umodel,
**_deploy_int8_unique_top.prototxt
```

BMNETU是针对BM168X的UFW(Unified Framework)模型编译器，可将某网络的umodel(Unified Model)和 prototxt编译成BMRuntime所需要的文件。而且在编译的同时，支持每一层的NPU模型计算结果和CPU的计算结果进行对比，保证正确性。具体参考：《NNToolChain用户开发手册》[BMNETU使用](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/bmnetu.html)。
