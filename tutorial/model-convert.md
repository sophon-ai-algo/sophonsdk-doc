# 2.2 跑通第一个例子：模型迁移

为了运行${BMNNSDK}/examples/SSD\__object/cpp\_cv\_bmcv\_bmrt_这个例子，需要使用原始Caffe模型生成2个模型：

* fp32\_ssd300.bmodel&#x20;
* int8\__ssd300.bmodel_

### 2.2.1 下载原始模型

**若您可以访问google网络硬盘**，则可以使用${BMNNSDK}/examples/SSD\_object/model下脚本文件`download_ssd_model.sh`从google网络硬盘下载原始SSD模型：

```
# 从google网盘下载原始SSD Caffe模型
cd ${BMNNSDK}/examples/SSD_object/model
./download_ssd_model.sh
```

脚本将在下载完压缩包后自动解压为当前目录下的models文件夹；并创建ssd300.caffemodel和ssd300\_deploy.prototxt的软链接指向models下的实体文件。这两个文件就是我们所需的原始Caffe模型文件。

**若您无法访问google网络硬盘**，则您需要手动从百度网盘下载所需文件，然后参考下述说明将文件解压到SDK中对应目录。

{% hint style="info" %}
**从百度网盘下载所需文件**

若您无法访问google网络硬盘，请从以下百度网盘链接下载后拷贝到该目录。

原始Caffe模型数据：models\__VGGNet\_VOC0712\_SSD\_300x300.tar.gz:_

> [https://pan.baidu.com/s/1pLxeLaVoisqN7IVyfrNhag](https://pan.baidu.com/s/1pLxeLaVoisqN7IVyfrNhag) Password: i4x9

量化使用的图片集数据：VOC712.tgz:

> &#x20;[https://pan.baidu.com/s/1o9e7uqKBFx0MODssm4JdiQ](https://pan.baidu.com/s/1o9e7uqKBFx0MODssm4JdiQ) Password：nl7v

**解压所需文件**

```
# 切换到指定目录
cd ${BMNNSDK}/examples/SSD_object/model
# 解压数据集到data目录下，完成后应该能看到data.mdb lock.mdb
tar zxf VOC712.tgz全路径 -C ./data/
# 将下载的文件models_VGGNet_VOC0712_SSD_300x300.tar.gz放到examples/SSD_object/model目录下
./download_ssd_model.sh
```
{% endhint %}

### 2.2.2 准备开发环境

转换模型前需要进入docker环境，切换到sdk根目录，启动docker容器：

```bash
# 从宿主机SDK根目录下执行脚本进入docker环境
./docker_run_bmnnsdk.sh
```

在docker容器内安装SDK及设置环境变量：

```bash
# 在docker容器内执行
cd /workspace/scripts
# 安装库
./install_lib.sh nntc
# 设置环境变量，注意此命令只对当前终端有效，重新进入需要重新执行
source envsetup_pcie.sh    # for PCIE MODE
source envsetup_cmodel.sh  # for SoC MODE
```

### 2.2.3 生成fp32 bmodel

```bash
# 切换到指定目录
cd /workspace/examples/SSD_object/model
# 生成fp32 bmodel
./gen_bmodel.sh
```

以上步骤正确执行后，会在out目录下生成fp32\_ssd300.bmodel 文件。

### 2.2.4 生成int8 bmodel

```bash
# fp32模型转换完成之后，接着执行如下指令生成int8 bmodel
./gen_umodel_int8bmodel.sh 
```

成功执行后，会看到out目录下多了一个文件int8\_ssd300.bmodel

至此，fp32和int8的模型迁移我们就完成了！
