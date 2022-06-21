# 1.6 更新BMNNSDK

我们将通过官方网站发布新版本的SDK：[官方下载中心](https://sophon.cn/drive/index.html)

通常而言，您只需要下载新版本的BMNNSDK(bmnnsdk2-bm1684\_vx.x.x.tar.gz)；若您使用基础开发镜像，且基础开发镜像需要更新时，我们会在BMNNSDK的下载页面给出特别提醒。

### **1.6.1 PCIE模式下的更新**

通常而言，您只需要下载新版本的BMNNSDK(bmnnsdk2-bm1684\_vx.x.x.tar.gz)重新安装驱动，驱动安装脚本会自动卸载旧版本的驱动，然后安装新版本的驱动。

需要注意的是，PCIE加速卡中的固件程序通常不需要更新，当需要更新时，我们会在相应版本的Release Notes中给出说明。

### **1.6.2 SoC模式下的更新**

SoC模型下有多种更新固件的方式：

* （1）<mark style="color:green;">**文件替换**</mark>直接更新[kernel、预编译的SDK库以及bootloader等文件](https://developer.sophgo.com/site/index/material/12/55.html)：文件替换方式是指在SoC系统中直接通过替换对应文件的方式分别升级bootloader、kernel和SDK等其它软件。这种方式有一定的风险，如不同软件组件之间的版本匹配、文件损坏等。请参考《[智算模组SM5软件开发指南](https://sophon-file.sophon.cn/sophon-prod-s3/drive/22/01/05/15/%E7%AE%97%E4%B8%B0SM5%E7%B3%BB%E5%88%97AI%E8%AE%A1%E7%AE%97%E6%A8%A1%E7%BB%84%E7%9A%84SOC%E6%A8%A1%E5%BC%8F%E8%BD%AF%E4%BB%B6%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97\_V1.5.pdf)》_2.2软件更新 b.文件替换_ 章节。
* （2）使用<mark style="color:green;">**SD卡刷**</mark>烧写整个固件：这种方式最为干净可靠，理论上只要您的SE5/SM5硬件没有损坏，都可以进行SD卡刷机，具体步骤请参考《[SE5用户手册](https://sophon-file.sophon.cn/sophon-prod-s3/drive/21/08/31/%E6%99%BA%E7%AE%97%E7%9B%92SE5%E7%94%A8%E6%88%B7%E6%8C%87%E5%AF%BC%E6%89%8B%E5%86%8C\_v1.2.pdf)》6.1节 系统升级或《[智算模组SM5软件开发指南](https://sophon-file.sophon.cn/sophon-prod-s3/drive/22/01/05/15/%E7%AE%97%E4%B8%B0SM5%E7%B3%BB%E5%88%97AI%E8%AE%A1%E7%AE%97%E6%A8%A1%E7%BB%84%E7%9A%84SOC%E6%A8%A1%E5%BC%8F%E8%BD%AF%E4%BB%B6%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97\_V1.5.pdf)》_2.2软件更新 a.SD卡刷机_ 。（注意：带有预置算法应用的卡刷包和[干净系统的卡刷包](https://developer.sophgo.com/site/index/material/12/49.html)是不一样的，请在升级前核实清楚您的需求，并向技术支持获取相应卡刷包；<mark style="color:red;">**卡刷会重写整个eMMC，也即您存储在eMMC的数据全部会丢失，请务必做好数据备份。**</mark>）
* （3）通过以太网，使用<mark style="color:green;">**tftp刷机**</mark>[专用文件](https://developer.sophgo.com/site/index/material/12/69.html)升级：请参考《[SM5开发手册](https://sophon-file.sophon.cn/sophon-prod-s3/drive/21/12/06/18/%E7%AE%97%E4%B8%B0SM5%E7%B3%BB%E5%88%97AI%E8%AE%A1%E7%AE%97%E6%A8%A1%E7%BB%84%E7%9A%84SOC%E6%A8%A1%E5%BC%8F%E8%BD%AF%E4%BB%B6%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97\_V1.4.pdf)》7.4 使用tftp刷机。
*   （4）使用<mark style="color:green;">**DDT设备扫描工具**</mark>更新：请联系技术支持获取，目前仅提供Windows客户端。需要注意的是，DDT设备扫描工具依赖于我方安装在SE5/SM5中的服务程序，若您使用自己定制的固件和操作系统，本方式不一定适用。

    > DDT 设备扫描工具是算能科技SE5 和 SM5 产品（以下简称产品）配套的辅助工具，它主要提供如下两种功能：
    >
    > 1. 自动扫描：发现同一局域网内的所有相关 SE5 或 SM5 产品，支持 IP 地址等基础信息更改。
    > 2. 软件升级：支持对勾选的指定产品进行单个或者批量软件升级。

{% hint style="info" %}
通常情况您只需要使用方式（1）升级；当版本跨度比较大时，建议您通过方式（2）卡刷方式升级，对于无法使用卡刷方式升级的情况，您可以使用方式（3）或（4）升级。
{% endhint %}
