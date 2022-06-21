# 4.4 解码模块

关于解码详细内容请参考[《多媒体用户开发手册》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/multimedia\_guide/html/index.html)。

关于ffmpeg解码python接口请参考[《SAIL用户开发手册》](https://doc.sophgo.com/docs/2.7.0/docs\_latest\_release/sophon-inference/html/index.html)。

本章主要介绍以下两点内容：

* OpenCV解码
* FFmpeg解码

## 4.4.1 OpenCV解码

OpenCV支持YUVI420/BGR格式输出，为了提高性能，示例中解码输出设置yuv格式数据。

简单示例如下：

```cpp
  cv::VideoCapture cap;
　if (!cap.isOpened()) {
　  cap.open(input_url);
  }
  cap.set(cv::CAP_PROP_OUTPUT_YUV, 1.0); //设置输出YUVI420格式数据，如选择BGR输出则注释掉此行代码
  cv::Mat *img = new cv::Mat;
  cap.read(*img);
  //do something
  ......
  //end
  delete img;
```

​ cap.set接口函数对输出格式设置， cap::read获取cv::Mat对象img，img数据接下来需要通过图像运算加速接口（bmcv模块）对数据进行推理前的预处理操作。

## 4.4.2 FFmpeg解码

* C编程接口初始化配置:

```cpp
// ffmpeg默认输出NV12压缩格式数据, 初始化解码器配置方法如下：
/*set compressed output*/
av_dict_set(&opts, "output_format", "101", 0);

if ((ret = avcodec_open2(*dec_ctx, dec, &opts)) < 0) {
   fprintf(stderr, "Failed to open %s codec\n",
               av_get_media_type_string(type));
   return ret;
}
```

请参考${BMNNSDK}/examples/SSD\_objext/cpp\_ffmpeg\_bmcv\_bmrt/main.cpp中相关内容。

* Python编程接口

```python
import sophon.sail as sail
decoder = sail.Decoder(filename)
img0 = decoder.read(handle)   #默认输出yuv i420格式
```
