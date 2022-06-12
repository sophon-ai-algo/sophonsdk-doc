# 1.4 安装SDK

{% hint style="info" %}
**开发环境与运行环境：**

开发环境是指用于模型转换或验证以及程序编译等开发过程的环境；运行环境是指在具备Sophon设备的平台上实际使用设备进行算法应用部署的运行环境。

开发环境与运行环境可能是统一的（如插有SC5加速卡的x86主机，既是开发环境又是运行环境），也可能是分离的（如使用x86主机作为开发环境转换模型和编译程序，使用SE5盒子部署运行最终的算法应用）。

但是，无论您使用的产品是Soc模式还是PCIE模式，您均需要一台x86主机作为开发环境；您的运行环境可以是任何已经我们测试支持的系统平台。
{% endhint %}

如果是PCIE模式，那么您需要将PCIE加速卡插到主机中，在宿主机上安装驱动程序，然后按照指引配置docker环境，这个环境既是开发环境也是运行环境。当然您也可以基于我们提供的docker开发环境，只保留系统运行时库的相关包，并添加您需要的库包以及其他程序代码，构建您自己部署在生产环境中的docker镜像。

如果是SoC模式，那么您需要按照指引配置docker环境，docker将工作在CModel模式，为您提供模型转换和程序交叉编译的开发环境；待程序编译好后，您需要手动将编译好的程序拷贝到目标系统(SE5/SM5)中运行执行。

### 典型开发环境

{% tabs %}
{% tab title="Linux开发环境" %}
* 一台安装了Ubuntu16.04/18.04/20.04的x86主机，运行内存建议12GB以上
* 安装Docker：参考《[官方教程](https://docs.docker.com/engine/install/)》
* 下载SophonSDK开发包：参考《[操作教程](../get.md)》

{% hint style="info" %}
注意：若您使用国产CPU或操作系统的主机，模型转换还需要使用一台x86主机完成，开发及部署可以直接在裸机上进行。若有问题，请联系我们获取技术支持。本教程后续的操作若无特殊说明，均是在x86主机上的ubuntu的docker开发镜像中。
{% endhint %}



安装和配置方法请参考：[on-linux.md](on-linux.md "mention")
{% endtab %}

{% tab title="Windows开发环境" %}
**windows下进行模型转换**

您可以安装Docker Desktop，使用Docker Desktop您可以依托WSL2在windows下加载我们提供的Ubuntu开发镜像，从而完成模型转换工作，您需要准备：

* 一台安装了Windows10+的x86主机，运行内存建议12GB以上
* 获取并安装Docker Desktop：参考《[官方教程](https://docs.docker.com/desktop/windows/install/)》
* 获取SophonSDK2开发包：参考《[操作教程](../get.md)》



安装和配置方法请参考：[on-windows10.md](on-windows10.md "mention")
{% endtab %}
{% endtabs %}

{% hint style="warning" %}
**注意：**

SophonSDK是一个支持多种平台的开发包。为了适应不同硬件平台和编译器的需求，开发者拿到SDK解压缩后，需要运行一个简单的安装脚本，此安装脚本会根据用户当前的主机环境调整安装适配的程序版本，如ABI（应用程序二进制接口）版本。因此，不建议拷贝解压缩后的文件夹到其他机器使用，确有拷贝需求时，请拷贝SDK原始压缩包，然后重新解压缩再安装。

* 比如CentOS和Ubuntu下默认的ABI格式不一样，无法通用，拷贝后的文件执行时会报找不到符号的错误；
* 当使用NTFS格式的移动存储设备拷贝解压后的文件时，特别是在windows下和linux之间拷贝文件时，极有可能造成文件链接或so文件损坏。
{% endhint %}
