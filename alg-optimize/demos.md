# 4.7 实例演示

我们在${BMNNSDK}/examples下为用户提供了C/C++/Python三种编程语言覆盖预处理推理接口用例。&#x20;

示例目录命名规则：编程语言+解码模块+预处理模块+推理接口模块

| ssd300示例目录              | 软件流程                                                            | 编程接口语言  | 运行环境     |
| ----------------------- | --------------------------------------------------------------- | ------- | -------- |
| cpp\_cv\_cv\_bmrt       | opencv解码 （BGR输出）+ opencv预处理 + inference + 后处理                   | C / C++ | soc/pcie |
| cpp\_cv\_bmcv\_bmrt     | opencv解码（yuv i420输出）+ bmcv预处理 +   inference + 后处理               | C / C++ | soc      |
| cpp\_cv\_cv+bmcv\_bmrt  | opencv解码（yuv i420输出）+   cv::bmcv预处理 + bmcv预处理 + inference + 后处理 | C / C++ | soc      |
| cpp\_ffmpeg\_bmcv\_bmrt | ffmpeg解码 （yuv压缩输出）+   bmcv预处理 + inference + 后处理                 | C / C++ | soc/pcie |
| cpp\_multi\_bmcv\_bmrt  | 多线程性能测试用例   ffmpeg/opencv解码+cv+bmcv+inference+后处理+jpg编码         | C / C++ | soc      |
| cpp\_cv\_cv+bmcv\_sail  | opencv解码（yuv i420输出）+ cv::bmcv预处理 +   bmcv预处理 + inference + 后处理 | C++     | soc      |
| cpp\_cv\_bmcv\_sail     | opencv解码（yuv i420输出）+   bmcv预处理 + inference + 后处理               | C++     | soc      |
| cpp\_ffmpeg\_bmcv\_sail | ffmpeg解码 （yuv压缩输出）+   bmcv预处理 + inference + 后处理                 | C++     | soc/pcie |
| py\_ffmpeg\_bmcv\_sail  | ffmpeg解码 （yuv压缩输出）+   bmcv预处理 + inference + 后处理                 | python  | soc/pcie |

本章主要用cpp\_cv\_bmcv\_bmrt、cpp\_ffmpeg\_bmcv\_bmrt用例来做以下两种模式下的编译运行演示。以下示例演示默认用户已经按照第三章内容进行了bmodel的转换。

* PCIE模式用例演示
* SoC模式用例演示

本示例需要使用到的测试视频（下载后，请保存到${BMNNSDK}/res/video/ 目录）：

{% file src="../.gitbook/assets/test_car_person.mp4" %}

## **4.7.1 PCIE模式用例演示**

1.  **在x86 Linux开发主机上解压sdk开发包并运行docker开发环境，本示例都基于此docker环境，Docker环境的按照请参考《**[**1.5.1环境配置**](../bmnnsdk2/setup/on-linux.md)**》**

    ```
    # 在宿主机上解压缩SDK软件包
    tar –zxf  bmnnsdk2-bm1684_v<x.x.x>.tar.gz
    cd bmnnsdk2-bm1684_v<x.x.x>/scripts
    # 在宿主机上安装驱动
    sudo ./install_driver_pcie.sh && cd ..
    # 运行docker开发容器
    ./docker_run_bmnnsdk.sh
    ```

    ```
    # 在docker开发容器中
    cd /workspace/scritps
    # 安装软件包
    ./install_lib.sh nntc
    # 设置环境变量
    source envsetup_pcie.sh
    # 安装SAIL包，测试py_ffmpeg_bmcv_sail时需要
    cd /workspace/lib/sail/python3/pcie/py35 && pip3 install sophon-<x.x.x>-py3-none-any.whl
    # 下载测试视频
    mkdir /workspace/res/video
    wget -O /workspace/res/video/test_car_person.mp4 https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FsTrToIfjXO6dEufUX44h%2Fuploads%2Fg6WElN0jsdW7ZsK26daI%2Ftest_car_person.mp4?alt=media&token=2b38ff64-1d25-4432-a770-2318df120a2e
    ```
2.  **在x86 Linux开发主机上编译及运行实例代码**

    ```
    cd /workspace/examples/SSD_object/cpp_ffmpeg_bmcv_bmrt/
    make -f Makefile.pcie clean && make -f Makefile.pcie
    # 编译后会在目录下生成
    # USAGE:
    #  ./ssd300_ffmpeg_bmcv_bmrt.pcie <video url> <bmodel path> <frames> <dev id>
    # 下载
    # float32模型测试
    ./ssd300_ffmpeg_bmcv_bmrt.pcie /workspace/res/video/test_car_person.mp4 ../model/out/fp32_ssd300.bmodel 10 0
    # int8模型测试
    #./ssd300_ffmpeg_bmcv_bmrt.pcie /workspace/res/video/test_car_person.mp4 ../model/out/int8_ssd300.bmodel 10 0
    ```

    程序运行过程中，可能会出现以下丢弃音频包或者视频帧数据包错误的字样，属正常现象：

    ```
    packet contain audio data ,drop this packet
    ** error!! decode_packet error
    ```

    终端会打印模型检测结果：

    ```
    [0]frame 1 - need to draw 2 bbox
    encoded image size is 36952
    [0]frame 2 - need to draw 2 bbox
    encoded image size is 35696
    [0]frame 3 - need to draw 2 bbox
    encoded image size is 36288
    [0]frame 4 - need to draw 2 bbox
    encoded image size is 36280
    ```

    最后也会在results目录下生成检测结果图片，可查看结果图片验证模型检测结果。
3.  **pcie状态监控**

    ```
    $ bm-smi   #此命令用于检测pcie工作状态，tpu，mem使用率, 板卡温度等
    ```

## 4.7.2 SOC模式用例演示

1.  **在x86 Linux开发主机上解压sdk开发包并运行docker开发环境，本实例都基于此docker环境，Docker环境的按照请参考《**[**1.5.1环境配置**](../bmnnsdk2/setup/on-linux.md)**》**

    ```
    # 以下命令在宿主机上执行
    # <xx.xx.xx>为SDK压缩包的版本号，需根据实际情况替换为相应的版本号
    tar –zxf bmnnsdk2-bm1684_v<xx.xx.xx>.tar.gz
    cd bmnnsdk2-bm1684_v<xx.xx.xx>
    ./docker_run_bmnnsdk.sh
    ```

    ```
    # 以下命令在容器内执行
    # 安装软件包
    cd /workspace/scripts
    ./install_lib.sh nntc
    # 设置环境变量
    source envsetup_cmodel.sh
    ```
2.  **在x86 Linux开发主机上生成 SSD\_object/model/out/int8\_ssd300.bmodel 后，执行下面的指令，编译实例代码：**

    ```
    cd ../examples/SSD_object/cpp_cv_bmcv_bmrt/
    make -f Makefile.arm clean && make -f Makefile.arm
    make -f Makefile.arm install
    ```
3.  **在x86 Linux开发主机上将交叉编译生成的程序install目录拷贝到soc单板**

    ```
    # 使用第三章转换的bmodel进行测试
    # <SOC_BOARD_IP>应当替换为实际的SOC单板IP地址
    # 以下命令在宿主机上执行，SOC设备默认用户名和密码均为linaro
    scp -r /workspace/install linaro@<SOC_BOARD_IP>:/data/
    ```
4.  **在Soc单板上运行程序进行测试：**

    在x86 Linux开发主机上操作

    ```
    # 登录到Soc单板中
    ssh linaro@SOC_BOARD_IP
    ```

    在Soc单板终端中操作

    ```
    # 以下命令在SOC设备中执行
    # 设置环境变量：参考1.5.3
    cd /data/install
    # 下载测试视频
    mkdir res/video
    wget -O res/video/test_car_person.mp4 https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FsTrToIfjXO6dEufUX44h%2Fuploads%2Fg6WElN0jsdW7ZsK26daI%2Ftest_car_person.mp4?alt=media&token=2b38ff64-1d25-4432-a770-2318df120a2e
    # float32模型测试
    ./bin/ssd300_cv_bmcv_bmrt.arm video res/video/test_car_person.mp4 model/ssd300/fp32_ssd300.bmodel 10 0
    # int8模型测试
    ./bin/ssd300_cv_bmcv_bmrt.arm video res/video/test_car_person.mp4 model/ssd300/int8_ssd300.bmodel 10 0
    ```

和PCIE模式一样，程序运行后终端会打印模型检测结果，并在results目录下生成图片结果out\_\*.jpg的检测结果图片，可查看结果图片验证模型检测结果。
