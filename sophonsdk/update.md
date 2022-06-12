---
description: Sophon
---

# 1.5 更新SDK

我们将通过官方网站发布新版本的SDK：[官方下载中心](https://sophon.cn/drive/index.html)

通常而言，您只需要下载新版本的SophonSDK(sophonsdk\_v\<x.y.z>.tar.gz)；基础开发镜像一般不会更新，若需要更新时，我们会在BMNNSDK的下载页面给出特别提醒。

### **1.5.1 PCIe模式下的更新**

通常而言，您只需要下载新版本的SDK更新驱动程序，驱动安装脚本会自动卸载旧版本的驱动，然后安装新版本的驱动。

需要注意的是，PCIe加速卡中的固件程序有时也需要更新，当需要更新时，我们会在相应版本的Release Notes中给出说明。

### **1.5.2 SoC模式下的更新**

SoC模型下有多种更新固件的方式，具体可参考FAQ文档《[智算盒子/模组刷机问题](https://doc.sophgo.com/docs/docs\_latest\_release/faq/html/devices/SOC/soc\_firmware\_update.html)》：

* （1）<mark style="color:green;">**文件替换**</mark>直接更新[kernel、预编译的SDK库以及bootloader等文件](https://developer.sophgo.com/site/index/material/12/55.html)：文件替换方式是指在SoC系统中直接通过替换对应文件的方式分别升级bootloader、kernel和SDK等其它软件。这种方式有一定的风险，如不同软件组件之间的版本匹配、文件损坏等。
* （2）使用<mark style="color:green;">**SD卡刷**</mark>烧写整个固件：这种方式最为干净可靠，理论上只要您的SE微服务器或SM模组硬件没有损坏，都可以进行SD卡刷机。（注意：<mark style="color:red;">**卡刷会重写整个eMMC，也即您存储在eMMC的数据全部会丢失，请务必做好数据备份。**</mark>）
* （3）通过以太网，使用<mark style="color:green;">**tftp刷机**</mark>[专用文件](https://sophon.cn/drive/69.html)升级，通常用于批量刷机操作。
*   （4）使用<mark style="color:green;">**DDT设备扫描工具**</mark>更新：请联系技术支持获取，目前仅提供Windows客户端。需要注意的是，DDT设备扫描工具依赖于我方安装在SoC设备中安装的服务程序，若您使用自己定制的固件和操作系统，本方式不一定适用。

    > DDT 设备扫描工具是SoC配套的辅助工具，它主要提供如下两种功能：
    >
    > 1. 自动扫描：发现同一局域网内的所有相关 SE或 SM 产品，支持 IP 地址等基础信息更改。
    > 2. 软件升级：支持对勾选的指定产品进行单个或者批量软件升级。

{% hint style="info" %}
通常情况您只需要使用方式（1）升级；当版本跨度比较大时，建议您通过方式（2）卡刷方式升级，对于无法使用卡刷方式升级的情况，您可以使用方式（3）或（4）升级。
{% endhint %}
