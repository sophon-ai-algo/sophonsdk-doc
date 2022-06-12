---
description: Sophon
---

# 1.6 SDK更新记录

### 3.0.0

> SDK
>
> * 移除了examples目录，相关例程统一放在github开源：[https://github.com/sophon-ai-algo/examples/](https://github.com/sophon-ai-algo/examples/)
>
>
>
> middleware
>
> *
>
>
>
> bm168x
>
> *
>
>
>
> bmcompiler与bmruntime
>
> * 增加BM1684X的支持
>
>
>
> Quantization量化工具
>
> *
>
>
>
> Sophon-inference&#x20;
>
> 1. 添加保存输入输出的接口 set\_dump\_io\_flag （python/c++）
> 2. Handle添加get\_sn接口 (python/c++)
> 3. 添加多卡推理引擎MultiEngine（python）
> 4. 添加putText和putText\_接口（python/c++）
> 5. 添加image\_add\_weighted接口 (python/c++)
> 6. 添加image\_copy\_to接口（python/c++）
> 7. 添加image\_copy\_to\_padding接口 （python/c++）
> 8. 添加set\_decoder\_env接口（python/c++），用来自定义ffmpeg参数
> 9. PaddingAttr添加构造函数（python/c++）
> 10. Engine添加 create\_input\_tensors\_map接口（python/c++）,根据bmodel创建input tensor map
> 11. Engine添加 create\_output\_tensors\_map接口（python/c++）,根据bmodel创建output tensor map
> 12. Engine对输入数据格式为fortran的numpy进行优化，优化了fortran转换为contiguous的时间，在普通PC机上对于640\*640的彩色图像在普通pc机上时间由40ms，缩短为3.5ms
> 13. 添加nms接口（python/c++）
>
>
>
> SoC固件
>
> *
>
>

### 2.7.0

> middleware
>
> * 支持bmcpu opencv,即pcie模式下，在卡上cpu执行opencv的相应函数，已支持函数列表见《多媒体用户手册》文档
> * bmcv jpeg decoder接口当遇到硬件不支持的格式的时候，自动切换到turbojpeg软解码
> * 增加opencv capture.read\_record接口，解码同时提供码流录制功能
> * 提供opencv imread的解码鲁棒性，当图像存在错误的时，仍然尽可能输出可解码部分的图像。由IMREAD\_RETRY\_SOFTDEC标志位控制
> * 将gb28181中的sip协议库由GPL协议的osip库替换为自研的sip库
> * 增加opencv capture中的fourcc支持
> * opencv在x86下增加abi0/1两套库，abi0针对centos等低于gcc5的编译器，abi1针对ubntu系统
> * 修定部分4k视频下因为secondary axi ram不够导致的解码失败问题
> * 丰富vidmulti例子，融合了多路编码的命令行选项
> * bmcv::toBMI增加了8SC3/8SC1类型的转换
> * bmcv::dumpMat增加对视频压缩格式的支持
> * 增强错误码流的鲁棒性处理，当码流错误导致底层堵塞的时候，avcodec\_decode\_video2或者send\_packet/receive\_frame接口会返回-1，以便上层应用重新连接或者做相应处理
> * 一些bug修订
>
>
>
> bm168x
>
> * PCIE加载驱动的时候默认使能A53。 &#x20;
> * 支持PCIE虚拟网卡功能。
> * bm-smi&#x20;
>   * a53 使能时，bm-smi recovery重新加载a53
> * 支持PCIE MIX MODE ，pcie 模式下，使能完整的soc 功能，推理，视频图像编解码任务在soc 环境下完成，pcie 只作为通信通道。
>
>
>
> bmcompiler与bmruntime
>
> * 增加了新的算子支持和优化
> * 改进了bmodel及bmruntime的内存分配机制，可以支持大模型运行，如BasicVSR
> * 增加了数据统计模式，通过export BMCOMPILER\_STAT\_ERR=1，可以在开比对情况下，会统计层数据的相似度，不会因为个别数据超过阈值而中断编译
> * 代码结构优化：与bmlib解耦、bmcompiler layer重构等
> * bug fix
>
>
>
> Quantization量化工具
>
> * 支持新的ubuntu16.04+python3.7 docker
> * U-FrameWork优化制作lmdb程序接口，提供ufwio python安装包，易于嵌入用户开发环境制作lmdb。
> * 删除convert\_imageset二进制工具，改用上述ufwio接口制作lmdb，提供制作python例程可以直接使用或者修改使用。
> * 量化工具增加MSE,PERCENTILE量化算法。
> * auto-cali整合到ufw whl包，便于依赖管理。代码进行了重构，优化一键量化调用接口，增加了更多的自动量化策略。推荐用户cv类量化优先使用一键量化。
> * 增加新版本可视化工具，旧版可视化工具暂时并存。新版工具展示网络结构，更加方便操作，推荐使用新版本可视化工具。
> * bug-fix
>
>
>
> Sophon-inference&#x20;
>
> * 重构头文件，隐藏实现细节，提高兼容性
> * 修复crop/resize/convert等接口会将传入的指定了输出格式的BMImage强制转换为BGR\_PLANAR的问题
> * 增加了打印推理过程中主要耗时情况的开关接口set\_print\_flag()
> * Python中sail.Decoder删除了以bm\_image为返回值的read\_接口
> * BMImageArray中增加了从BMImage中copy和attach数据的接口copy\_from()和attach\_from()
> * 修改了Python中sail.Tensor的初始化方法，添加own\_sys\_data标志位，支持创建只包含设备内存的Tensor
> * Bmcv中增加了适用于bm\_image的图片保存接口imwrite\_
> * Python中sail.Bmcv增加了适用于bm\_image的绘制矩形接口rectangle\_()
> * Python中sail.Bmcv增加了接口vpp\_convert\_format()
> * Python中sail.Bmcv增加了接口convert\_format()
> * Python中sail.Bmcv增加了接口crop\_and\_resize\_padding()
> * 增加了Python开发中的语法提示
> * 修复若干文档错误
>
>
>
> SE5固件
>
> * SE5 v2支持
> * 解耦gate相关（预置的人脸抓拍识别应用）- 仅针对Ubuntu20.04版本
>   * 把sophon system 这套界面和restful api 接口移植到全家桶box，以提供给客户一些系统信息（tpu/vpu/fan等）
>   * 把gate 文件系统里 bm\_bin的一些基本命令移植到全家桶box，提高用户体验
>   * oemconfig.ini 生成
>   * 增加升级命令（bm\_upgrade\_runtime），从官网下载最新升级包，并升级
>   * qt5.14的lib 移植到box
>   * SophUI(hdmi 显示界面)，显示信息，修改ip
>
>
>
> documents
>
> * 之前随SDK发布的各个模块文档修改为统一在[官网文档中心](https://developer.sophgo.com/document/index.html)发布，可在线查看或下载PDF

### 2.6.0

> bmlib\&driver:
>
> 1. 新增了loongarch64 平台的支持
> 2. 修正了firmware 超过1M 后会overflow的问题
>
> \
> bmvid / middleware、bmcv:
>
> 1. 增加proc中vpu/jpu使用率信息
> 2. opencv videowrite增加对rtsp/rtmp的直接支持，并增加示例
> 3. 大幅更新multimedia\_guide文档，增加multimedia\_faq文档
> 4. 更新并完善ffmpeg中bm-scale filter的功能：增加更多色彩的csc转换，支持常规模式下的滤波用法
> 5. pcie opencv使能bmcpu功能，提供A53下的font/rectangle/line等基本drawing操作
> 6. bmcv/vpp增加对argb颜色的支持
> 7. ffmpeg bmcodec增加对loop-decoding的支持
> 8. 增加对loongarch64平台的支持
> 9. windows/mips64/sw64/loogarch64平台增加x86 linux下的sample用例
> 10. 增加opencv/ffmpeg的各种示例，展示ffmpeg+bmcv之间的切换调用
> 11. bug修正：支持crop图像的jpeg编码，减少opencv下视频解码的内存占用空间，移除libbm\_x264，opencvModule.cmake中移除绝对路径等
>
>
>
> Sophon-inference:
>
> 1. 修复bugs，增强稳定性
> 2. 增加了帧率获取接口
> 3. 支持int32模型输入类型
> 4. 增加多进程Demo
> 5. 文档修改
>
>
>
> nntc:
>
> 1. 增加了bmneto，支持onnx模型编译
> 2. bmnett支持tensorflow 2.x, saved\_model模型格式
> 3. 增加了conv3d、deconv3d等3d算子及相关优化，支持slowfast和3dunet等3d模型
> 4. 增加了strideslice、transpose、depth2space等优化，提升yolov5相关模型性能
> 5. 优化timestep过程，减少编译时间
> 6. 相关工具支持的python版本升级，支持python3.7
> 7. 修复若干bugs
>
>
>
> cali:
>
> 1. 文档修改
> 2. 图优化速度优化，c++实现代替python实现
> 3. reverse层量化支持，lstm，batchmatmul层量化设置为浮点推理
> 4. bugfix
>
>
>
> ufw:
>
> 1. 增加了支持onnx模型转umodel
> 2. 支持保留用户定义的输入输出名
> 3. 若干bug修复
>
>
>
> bsp:
>
> 1. 更新SM750驱动；增加XFS支持
> 2. 增加了pcie mixed mode支持；修正刷机包单个gz文件太大会越界的问题；升级开源sdk和newos打包脚本；增加lte modem service；修正ethtool工具版本问题
>
>

### 2.5.0

> bmlib\&driver:
>
> 1. Windows SDK开发支持
>    * 目前驱动可以在debug模式下安装，支持单芯卡和三芯卡
>    * 支持bm-smi基本功能
>    * 支持VPU/JPU编解码基本功能
>    * 支持bm\_opencv， ffmpeg库加速
>    * 支持网络推理运行时库
> 2. 增加了vpu、jpu利用率的统计和显示
> 3. 在申威服务器上做了适配
> 4. 更改了Bm-smi的显示界面
> 5. 增加了执行Bm-smi recovery操作时的保护，防止系统崩溃
>
>
>
> bmcv:
>
> 1. 增加2个算子： bmcv\_image\_axpy, bmcv\_image\_lapacian
> 2. vpp padding 支持带有 stride。
>
>
>
> bmvid / middleware:
>
> 1. 支持SC5模式下A53 opencv运行模式，支持warp, affine, sobel, erode, dialet, morphologyEx, line, calcOpticalFlowPyrLK, OpticalFlowFarneback, calcHist, boxFitler, bilateralFilter, gaussianBlur,
> 2. 修正rtsp mjpeg解码的问题
> 3. 修正硬件编码下flv的打包问题
> 4. ffmpeg支持lame mp3解码
> 5. ffmpeg支持hls协议
> 6. ffmpeg命令行增加zero\_copy选项，支持硬件解码的yuv输出
> 7. 扩展平台支持到龙芯，申威，以及windows系统
> 8. 增加vpu/jpu usage信息到proc输出
> 9. bug修正
>
>
>
> Sophon-inference:
>
> 1. bug fix
> 2. 文档修正
>
>
>
> nntc:
>
> 1. 增加用户自定义tpu layer插件，支持bmkernel编写某个layer并插入到网络
> 2. 增加用户自定义编译优化插件及demo
> 3. nms最大支持65536个检测框
> 4. bmnetu支持gru layer
> 5. bmcpu/bmruntime适配windows/mips64/sw64
> 6. int8模型动态编译支持conv3d/pooling3d
> 7. 性能优化及bug修复
> 8. 文档更新
>
>
>
> cali:
>
> 1. 合并leaky relu层等优化
> 2. 增加使用最大值量化选项
> 3. 文档更新
> 4. bug fix
>
>
>
> ufw:
>
> 1. 优化内存使用，有效减少50%内存占用
> 2. layer增加Tag功能，可以对Layer的功能进行归类和特性描述
> 3. 增加了对CFG语义分析
> 4. 修正部分bug
>
>
>
> bsp:
>
> 1. ATF增加a53 soft reboot功能；u-boot修复重启进入命令行后mcu watchdog timeout问题；linux增加efuse secure key保护等功能，修正tpll切换方式
> 2. kernel关闭errutam 843419，修正cpufreq bug
> 3. 支持kernel5.4和ubuntu20.04系统；兼容新旧两种命名的its node；为sm5增加了一种dts（不兼容！）；debian增加ethtool、gate的设备发现工具等；修改lpddr4参数；改善u-boot usb兼容性；kernel4.9增加usb acm支持，删除重复的realtek config
> 4. 增加SE5 lite支持；修正memory layout工具；修正SM5 mini低配版配置
> 5. 更新SM750驱动；增加XFS支持
>
>

### 2.4.0

> bmlib\&driver:
>
> 1. 增加板卡管理接口
> 2. 增加mips工具链和功能支持，达到给客户试用水平
> 3. 增加Windows SDK bmlib及部分测试用例cmakelist文件和驱动、Bmlib平台适配代码（尚未达到release水平）
> 4. 修复A53使能后无法重复装驱动的问题
> 5. 重构Linux下面proc下面文件的组织方式
> 6. 重构bm-smi代码和界面组织，支持以卡为单位显示
> 7. 增加了vpp模块hang后软复位功能
> 8. 增加了bmlib中获取memory heap信息的接口
> 9. 修复INTC iic2中断被mask导致的smbus读取温度失败问题
>
>
>
> bmcv:
>
> 1. 新增功能：put\_text、draw\_lines；
> 2. PCIe模式下支持使能A53，使用片上CPU完成部分操作。
>
>
>
> bmvid / middleware:
>
> 1. 增加mips64平台支持
> 2. 去除bmvid 自有API中的assert判断，返回错误值
> 3. 统一所有的jpeg解码输出到planar格式
> 4. 增加dumpBMImage对float32 int8等格式的支持
> 5. 更新osip库，提高gb28181的兼容性和稳定性
> 6. 调整底层调度，多路编解码时调度更加均匀
> 7. soc下去除8路限制，支持到24路视频编码
> 8. 修补问题，增强稳定性\
>
>
> Sophon-inference:
>
> 1. Python功能添加base64支持
> 2. 增强Bmcv::imwrite功能，支持更多格式。
> 3. BMImage处理方面的一些优化
>
>
>
> nntc:
>
> 1. 【BMNETC】Power算子bugfix，支持L2Normalize算子
> 2. 【BMNETC】修复了rpnproposal算子计算出错的bug
> 3. 【BMNETP】pytorch版本升级到1.8.1
> 4. 【BMNETP】支持BERT模型
> 5. 【BMNETT】增加arcsin、arccos、arcsinh、arccosh、arctanh、cosh、sinh、tan等三角函数的支持
> 6. 【BMNETU】新layer支持：ShapeRange
> 7. 【BMNETU】python接口支持int8 umodel的拆分功能
> 8. 【BMNETU】增强了daily test
> 9. 【BMNETU】Tile layer支持两个输入
> 10. 【BMNETU】修复了包含reorg fix8b layer的动态网络bug
> 11. 【BMCOMPILER】重构graph filter优化器
> 12. 【BMCOMPILER】重构layer group优化器成pass结构
> 13. 【BMCOMPILER】优化了active SILU fix8b的性能，yolov5性能有提升
> 14. 【BMCOMPILER】增加了对active SIGN layer的支持
> 15. 【BMCOMPILER】增加了Timestep合并优化和修复了3IC优化问题，yolov3等检测网络性能有些提升
> 16. 【BMCOMPILER】TOPK算子使用TPU加速，包含TOPK的网络有性能提升
> 17. 【BMLANG】stride类计算性能优化和支持coeff输入
> 18. 【BMLANG】condition\_select计算支持数据广播
> 19. 【BMLANG】支持Shape Tensor控制输入，并更新bmlang demo rgb2yuv支持crop区域可动态变化
> 20. 【BMLANG】多个使用相同mask的masked\_select算子的性能优化
> 21. 【BMLANG】nms算子有数倍以上的性能提升
> 22. 【BMRUNTIME】去除了exit直接退出，使用c++ exception返回错误值
> 23. 【BMRUNTIME】对龙芯mips的支持
> 24. 【BMRUNTIME】包含FC层的网络也支持分辨率动态可变
> 25. 【BMPROFILE】修复了layer和GDMA显示错乱的问题
> 26. 【BMKERNEL】支持mips64
> 27. 【BMKERNEL】增加BMRT + BMKERNEL跑yolov3 backbone + 后处理的demo
> 28. 【BACKEND 1684】增加高性能分组topk的bmkernel demo
> 29. 【BACKEND 1684】修复了包含reduce的动态网络跑很多轮后会hang住的问题
> 30. 【BACKEND 1684】支持任意多算子的动态网络
> 31. 【BACKEND 1684】修复3d max pooling的一个计算错误bug
> 32. 【BACKEND 1684】优化了4N/1N转换的性能，一些网络性能会有提升
>
>
>
> cali:
>
> 1. 修复 batchnorm leakyrelu等layer的bug
> 2. 增加is\_shape\_layer标记更好地支持shape相关操作，增加shapeRange、expandDims、shapeAssign以及shapeCast等layer支持int32数据
> 3. 整理forward\_with\_float功能，增加稳定性
> 4. 增加用ADMM方式统计阈值
> 5. 完善auto\_calib功能
>
>
>
> ufw:
>
> 1. 默认支持包含控制流的网络
> 2. 支持任意动态shape的网络，以及包含运行时推断shape的网络
> 3. 部分bugfix
> 4. 部分layer功能增强\
>
>
> bsp:
>
> 1. 增加recovery mode下ramdisk size；增加usb刷机功能
> 2. 增加SM5 min宽温版支持；修正宽温版调频温度点和CPU调频机制；调整pcie rc初始化代码以支持没有refclk0的板卡；spacc secure key功能；u-boot和BL2瘦身；升级flash update工具；增大recovery分区以支持OTA；bind pcie中断到cpu7；增加fl2000重新枚举功能
> 3. ATF增加a53 soft reboot功能
>
>

### 2.3.2

> bmlib\&driver:
>
> 1. 增加了对mips适配
> 2. 增加了一些mips体系结构的库
> 3. 修复若干SC5P的bug
> 4. 增加了一些支持Windows编译的cmake代码和脚本
> 5. 增加了对SM5-W的支持
>
>
>
> bmcv:
>
> 1. 修复几个corner case的bug；
> 2. 新增接口：absdiff、threshold、fft、max\_min、calc-hist；
> 3. 整理后端代码存放位置，只有个别api放于itcm，以后新增的均放置于ddr。
>
>
>
> bmvid:
>
> 1. 支持龙芯平台编译
>
>
>
> middleware:
>
> 1. 扩展opencv支持到512路视频
> 2. ffmpeg osip库更新
> 3. 修正bug
> 4. 支持龙芯平台编译
>
>
>
> Sophon-inference:
>
> * 修正了文档中URL地址连不上的问题。
>
>
>
> nntc:
>
> 1. 【BMLANG】增加deconv的perchannel int8计算demo。
> 2. 【BMLANG】Select/Condition select支持int8。
> 3. 【BMLANG】优化了NMS的性能
> 4. 【BMNETC】增加CONV3D和POOLING3D的支持。
> 5. 【BMNETT】增加用户自定义输入数据和数据类型。
> 6. 【BMCOMPILER】修复了一些bug来支持客户模型。
> 7. 【BMCOMPILER】优化了跑INT8网络的等待时间。
> 8. 【BMNETP】增加BMM、LAYER NORM、EINSUM算子的支持。
> 9. 【BMNETU】完善的单元测试。
> 10. 【BMPROFILE】增加CSV的导出功能。
> 11. 【BMPROFILE】增加解析Global memory操作的功能。
> 12. 【BMRUNTIME】适配了龙芯。
> 13. 【BACKEND\_1684】优化了GDMA GEN CMD的时间开销。
> 14. 【BACKEND\_1684】修复了后端bug。
> 15. 【BACKEND\_1684】优化后的分组topk和全库topk的demo。\
>
>
> cali:
>
> 1. 修复batchnorm layer的bug
> 2. 增加auto\_calib功能
>
>
>
> ufw:
>
> 1. 修复若干bug
> 2. 增强了analysis工具的稳定性
> 3. 支持了conv per-channel计算
> 4. 移除了部分ufw blob data的python API
>
>
>
> bsp:
>
> 1. ATF里的DDR数据拆出一个单独的bin文件
> 2. 换用MCU watchdog
> 3. SM5宽温板卡支持
> 4. BSP SDK开源相关
>
>

### 2.3.1

> bmlib\&driver:
>
> 1. 增加设备管理接口并跟新文档
> 2. 增加MIPS体系结构工程
> 3. fix 编译中的warn信息
> 4. 增加对SC5P的适配
> 5. 重构了驱动中更新芯片和板级温度、tpu利用率的机制
>
>
>
> bmcv:
>
> 1. 新增sobel、gaussian-blur、add-weighted、dct、yuv2hsv、batch-topk算子；
> 2. 优化并扩展nms，使其最大可支持65535个box的输入，并提高其性能；
> 3. 扩展matmul，支持输出float32的类型；
> 4. bugfix
>
>
>
> middleware:
>
> 1. sobel接口的8UC1→8UC1，BORDER\_DEFAULT case采用硬件加速实现
> 2. gaussion\_blur接口的8UC1输入采用硬件加速实现
> 3. 增加对hikvision smart选项的支持
> 4. 优化opencv在yuv下的font字体渲染的效果
> 5. 更新multimedia文档
> 6. 提高稳定性，修补bug
>
>
>
> Sophon-inference:
>
> 1. 问题修正，稳定性提高
>
>
>
> nntc:
>
> 1. 【bmcompiler】对包含C axis CONCAT算子的网络有性能优化。
> 2. 【bmnetu】【bmnetp】增加3D Conv/Pooling的支持。
> 3. 【bmnetu】增加对多输入网络的支持。
> 4. 【bmnett】增加check ops的功能。
> 5. 【bmnetp】增加对Pytorch GRU/LSTM模型的支持。
> 6. 【bmnetp】升级到支持pytorch 1.7版本。
> 7. 【bmlang】Deconv算子支持16bit输出。
> 8. 【bmlang】增加性能优化后的分组topk业务程序demo。
> 9. 【bmlang】GEMM支持INT8输入/FP32输出，且支持perchannel的scale。
> 10. 【bmlang】增加deconv做perchannel量化计算的demo。
> 11. 【backend\_1684】nms算子在大于1024 box时比2.3.0有性能提升。
> 12. 【backend\_1684】1N、4N数据转换的性能提升。
> 13. 【all】BUGs修复，提高稳定性。
>
>
>
> ufw:
>
> 1. float计算支持了包含控制流的网络
> 2. UFW python blob 兼容numpy数据类型
> 3. UFW支持了部分空集输入和计算
>
> \
>
>
> bsp:
>
> 1. 预装perfetto工具
> 2. 预装板上编译kernel module需要的deb包
> 3. VPP driver代码优化
> 4. 使能PMU
>
>
