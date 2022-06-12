# 3.3.4 精度测试

精度测试是一个可选的操作步骤，用以验证经过 int8 量化后，网络的精度情况。

该步骤可以安排在部署描述的网络部署之前，并配合量化网络反复进行，以达到预期的精度。&#x20;

根据不同的网络类型，精度测试可能是不同的，精度测试常常意味着要进行完整的前处理和后处理以及精度计算程序开发。

Calibration-tools 对外提供了UFramework 的应用接口，可以对 umodel 进行 float32 或者 int8 推理，从而计算网络推理精度。

{% hint style="info" %}
在生成新的int8 bmodel后，网络可能需要验证精度损失，SDK提供不同类型网络的精度比对方式。

* 分类网络，通过修改网络输出层添加top-k：参考《量化工具用户开发手册》[分类网络的精度测试](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#id15)。
* 检测网络，通过ufw测试特定图片，与fp32网络比对：参考《量化工具用户开发手册》[检测网络的精度测试](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#id16)。
* 通过图形界面检查精度差异：参考《量化工具用户开发手册》[量化误差定性分析](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#id17)。
{% endhint %}

更多关于精度测试以及量化误差分析、量化技巧的内容请参考[《Quantization-Tools-User\_Guide》](https://doc.sophgo.com/docs/docs\_latest\_release/calibration-tools/html/module/chapter4.html#optional)。
