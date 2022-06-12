# 3.2 FP32 模型生成

​基于BMNNSDK2提供的BMNet工具链可以很方便地将原始第三方深度学习框架下训练的模型转换为BModel。

* bmnetc：编译Caffe模型
* bmnett：编译TensorFlow模型
* bmnetm：编译MXNet模型
* bmnetp：编译PyTorch模型
* bmnetd：编译Darknet模型
* bmneto：编译ONNX模型
* bmpaddle：编译PaddlePaddle模型

执行`source envsetup_xxx.sh`会自动安装以上转换工具，并在当前终端设置相关的环境变量。您也可以将环境变量写到配置文件`~/.bashrc`中。

{% hint style="warning" %}
**注意：**

对于有些模型，比如paddle-ocr-detection或其他算子中有很多累加或除法的模型，如果在转换过程中打开比对选项的话，会由于误差累计而导致比对结果超出允许的误差阈值范围，模型转换中断；还有一些有排序操作的模型，虽然误差不大，但会影响排序的顺序，从而导致比对出错、转换中断。对于这些情况，可以在转换过程中关闭cmp参数，不进行数据比对，待模型转换完成后再到业务层面验证转换后模型的精度。
{% endhint %}
