# 1.4.1 环境配置-Linux

我们提供了docker开发镜像供用户在x86主机下开发和部署使用，docker中已安装好了交叉编译环境以及开发工具依赖的库和软件。PCIe用户可基于此docker 进行开发和部署；SoC用户可基于此docker进行开发，部署时请将在开发docker中交叉编译好的程序拷贝至SoC平台（SE微服务/SM模组）中执行，相关运行环境的配置请参考[on-soc.md](on-soc.md "mention")。您也可以根据自己的需求在我们提供的docker镜像基础上定制自己的docker镜像。

{% hint style="danger" %}
**我们强烈建议新用户务必在x86主机上使用我们提供的docker基础开发镜像创建docker容器，在容器中按照步骤来进行各项操作，以规避系统及依赖包以及环境配置等问题带来的影响。**

请注意后续步骤适用SDK为sophonsdk\_v\<x.y.z>.tar.gz，其中\<x.y.z>为SDK版本号(x>=3)，会随着SDK的升级而不断变化。

其他平台的用户也需要使用x86主机作为开发环境完成模型转换，而后再交叉编译生成相应平台的程序拷贝到目标平台运行。
{% endhint %}

### **1.5.1.1 解压SDK压缩包**

```
tar zxvf sophonsdk_v<x.y.z>.tar.gz
cd sophonsdk_v<x.y.z>
```

#### **（驱动安装请在docker 之外宿主机上进行）**

### **1.5.1.2 驱动安装**

{% hint style="info" %}
提示：如果用户有Sophon PCIe加速卡，则需要按照如下方式进行驱动安装和卸载。PCIe模式支持x86、ARM、LoongArch龙芯、mips、sw申威等主机平台，这些平台的驱动文件各不相同，我们在SDK中提供了相应的驱动源码和编译安装脚本；若没有PCIe卡，则应当跳过本节，后续开发中使用CModel模式完成模型转换和程序的交叉编译。
{% endhint %}

#### **1. 检查PCIe加速卡是否正常被系统识别：**

打开终端执行 `lspci | grep Sophon` 检查卡是否能够识别，正常情况应该输出如下信息：

```
01:00.0 Processing accelerators: Bitmain Technologies Inc. BM1684, Sophon Series Deep Learning Accelerator (rev 01)
```

{% hint style="warning" %}
若PCIe加速卡没有被系统正常识别，则需要首先排除故障，通常引起PCIe加速卡未被正常识别的可能原因有：

* PCIe加速卡在插糟中没有插紧；
* 检查插卡的槽位是否是标准的X16槽位，X8槽位的功率支持通常最大只有45W，不建议使用；
* PCIe加速卡从PCIe直接供电，不需要外接电源，若连接了外接电源，可能导致卡不能被正常识别；
* 三芯片以上PCIe加速卡需要足够的散热条件，若风道和风量不能符合PCIe加速卡的被动散热要求，则需要通过BIOS将风扇转速设置到足够大或者假装额外的风扇进行散热。（[建议的风扇购买链接1](https://item.taobao.com/item.htm?id=36055254962\&ali\_refid=a3\_420434\_1006:1107611642:N:4VSdCmF2B094pPkh1WoYZQ%3D%3D:caf6d7709e50567abd191d8082c8d1f8\&ali\_trackid=1\_caf6d7709e50567abd191d8082c8d1f8\&spm=a230r.1.1957635.19) [建议的风扇购买链接2](https://item.taobao.com/item.htm?spm=a230r.1.14.1.663957b2uB9IkW\&id=561295966005\&ns=1\&abbucket=8#detail) [建议的风扇购买链接3](https://item.taobao.com/item.htm?spm=a230r.1.14.1.7e8c597eIKLjz8\&id=555295405824\&ns=1\&abbucket=8#detail)）
{% endhint %}

#### **2. PCIe环境驱动安装：**

*   x86主机：

    ```
    cd sophonsdk_v<x.x.x>/scripts
    sudo ./install_driver_pcie.sh
    ```

如果是其他主机，请执行相应的安装脚本`install_driver_xxx.sh`。

{% hint style="info" %}
**检查驱动是否安装成功：**

执行`ls /dev/bm*` 看看是否有`/dev/bm-sohponX (X表示0-N）`，如果有表示安装成功。 正常情况下输出如下信息：

/dev/bmdev-ctl /dev/bm-sophon0
{% endhint %}

#### **3. PCIe驱动卸载方式如下：**

*   x86主机：

    ```
    sudo ./remove_driver_pcie.sh
    ```

如果是其他主机，请执行相应的卸载脚本`remove_driver_xxx.sh`。

### **1.5.1.3 Docker 安装**

若已安装docker，请跳过本节。

```bash
# 安装docker
sudo apt-get install docker.io
# docker命令免root权限执行
# 创建docker用户组，若已有docker组会报错，没关系可忽略
sudo groupadd docker
# 将当前用户加入docker组
sudo gpasswd -a ${USER} docker
# 重启docker服务
sudo service docker restart
# 切换当前会话到新group或重新登录重启X会话
newgrp docker​ 
```

{% hint style="info" %}
提示：需要logout系统然后重新登录，再使用docker就不需要sudo了。
{% endhint %}

### **1.5.1.4 加载docker镜像**

{% hint style="info" %}
注意：后续版本的Docker名字可能会变化，请根据实际Docker名字做输入。
{% endhint %}

```bash
docker load -i x86_sophonsdk3_ubuntu18.04_py37_dev_22.06.docker
```

### **1.5.1.5 创建docker 容器进入docker**

```
cd sophonsdk_v<x.x.x>
# 若您没有执行前述关于docker命令免root执行的配置操作，需在命令前添加sudo
./docker_run_sophonsdk.sh
```

{% hint style="warning" %}
**提示：**上述启动脚本将在运行时检查是否有sophon加速设备，若物理机上安装了PCIe加速卡，且驱动已经正确安装，则脚本会将设备映射到docker容器内部，这样后续就可以在docker容器内部使用sophon设备运行推理程序了。
{% endhint %}

**（以下步骤在docker 中进行）**

### **1.5.1.6 工具安装及环境配置**

#### **PCIe模式**

对于PCIe模式，开发环境本身就可以作为运行环境，加载转换生成的BModel和编译生成的程序。

*   x86主机：

    ```
    cd  /workspace/scripts/
    ./install_lib.sh nntc
    source envsetup_pcie.sh
    ```

{% hint style="info" %}
若想在PCIe模式下Python中使用我们提供的BM-OpenCV，请设置以下环境变量，请根据实际路径修改：

export PYTHONPATH=$PYTHONPATH:/workspace/lib/opencv/pcie/opencv-python
{% endhint %}

#### **CModel模式**

对于目标平台为SoC等其他平台的情况，x86主机上通常没有Sophon PCIe加速卡，docker开发环境应当工作在CModel模式以完成模型转换和程序的交叉编译。

```bash
cd  /workspace/scripts/
./install_lib.sh nntc
source envsetup_cmodel.sh
```

### **1.5.1.7 验证**

您可以执行以下命令，验证开发环境中的交叉编译工具链是否配置成功：

* ```
  which aarch64-linux-gnu-g++
  # 终端输出内容
  # /data/release/toolchains/gcc/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin//aarch64-linux-gnu-g++
  ```

如果终端输出了aarch64编译的路径，则说明交叉编译工具链正确，开发环境是可以正常使用的。

若您需要使用SAIL模块，在非SoC平台下，您需要根据使用的python版本安装相应的pip包，请参考[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)中的安装说明。若您在SoC平台中使用SAIL模块，只需要设置环境变量即可，请参考[#1.5.3.3-yun-hang-huan-jing-pei-zhi](on-soc.md#1.5.3.3-yun-hang-huan-jing-pei-zhi "mention")。
