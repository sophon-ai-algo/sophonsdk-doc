# 4.2 C/C++编程详解

这个章节将会选取SSD检测算法作为示例，说明各个步骤的接口调用和注意事项。

{% hint style="info" %}
**样例代码路径：**examples/simple/ssd/cpp/cpp\_cv\_bmcv\_bmrt
{% endhint %}

因为SDK支持多种接口风格，因此一个简洁的示例代码不可能面面俱到。故而这个示例程序采用了OPENCV解码 + BMCV图片预处理的组合进行开发，这个组合兼顾了高效和简洁。

我们按照算法的执行先后顺序展开介绍：&#x20;

1. 加载bmodel模型
2. 预处理
3. 推理
4. 注意事项

## 4.2.1 加载bmodel

```cpp
...
string net_name_;

SSD::SSD(bm_handle_t& bm_handle, const string bmodel):p_bmrt_(nullptr) {

  bool ret;

  bm_handle_ = bm_handle;

  // init bmruntime contxt
  p_bmrt_ = bmrt_create(bm_handle_);
  if (NULL == p_bmrt_) {
    cout << "ERROR: get handle failed!" << endl;
    exit(1);
  }

  // load bmodel from file
  ret = bmrt_load_bmodel(p_bmrt_, bmodel.c_str());
  if (!ret) {
    cout << "ERROR: Load bmodel[" << bmodel << "] failed" << endl;
    exit(1);
  }

  const char **net_names;
  bmrt_get_network_names(p_bmrt_, &net_names);
  net_name_ = net_names[0];
  free(net_names);

  // get model info by model name
  net_info_ = bmrt_get_network_info(p_bmrt_, net_name_.c_str());
  if (NULL == net_info_) {
    cout << "ERROR: get net-info failed!" << endl;
    exit(1);
  }

  // get data type
  if (NULL == net_info_->input_dtypes) {
    cout << "ERROR: get net input type failed!" << endl;
    exit(1);
  }
  if (BM_FLOAT32 == net_info_->input_dtypes[0]) {
    threshold_ = 0.6;
    is_int8_ = false;
  } else {
    threshold_ = 0.52;

...
```

这个几个函数的用法比较简单和固定，用户可以参考NNToolchain手册了解更详细的信息。唯一需要强调的是net\_name\_字符串变量的用法：在推理代码中，模型的唯一标识就是他的net\_name\_字符串，这个net\_name\_需要在compile阶段就进行指定，算法程序也需要基于这个net\_name\_开发；例如，在调用inference接口时，需要使用模型的net\_name\_作为入参，让runtime作为索引去查询对应的模型，错误的net\_name\_会造成inference失败。

## 4.2.2 预处理

### **4.2.2.1 预处理初始化**

预处理初始化时，需要提前创建适当的bm\_image对象保存中间结果，这样可以节省反复内存申请释放造成的开销，提高算法效率，具体代码如下：

```cpp
...
// init bm images for storing results of combined operation of resize & crop & split
ret = bm_image_create_batch(bm_handle_,
                            INPUT_HEIGHT,
                            INPUT_WIDTH,
                            FORMAT_BGR_PLANAR,
                            DATA_TYPE_EXT_1N_BYTE,
                            resize_bmcv_,
                            MAX_BATCH);

if (!ret) {
  cout << "ERROR: bm_image_create_batch failed" << endl;
  exit(1);
}

// bm images for storing inference inputs
bm_image_data_format_ext data_type;
if (is_int8_) { // INT8
  data_type = DATA_TYPE_EXT_1N_BYTE_SIGNED;
} else { // FP32
  data_type = DATA_TYPE_EXT_FLOAT32;
}
ret = bm_image_create_batch (bm_handle_,
                             INPUT_HEIGHT,
                             INPUT_WIDTH,
                             FORMAT_BGR_PLANAR,
                             data_type,
                             linear_trans_bmcv_,
                             MAX_BATCH);

if (!ret) {
  cout << "ERROR: bm_image_create_batch failed" << endl;
  exit(1);
}
...
```

不同于bm\_image\_create()函数只创建一个bm\_image对象，bm\_image\_create\_batch()会根据最后一个参数batch，创建一组bm\_image对象，而且这组对象所使用的data域是物理连续的。使用物理连续的内存是硬件加速器的特殊需求，在析构函数，可以使用bm\_image\_destroy\_batch()对内存进行释放。

除了提前申请物理连续内存，还可以在初始化过程中配置好预处理操作的参数，方法如下：

```cpp
...
// init linear transform parameter, X*a + b, int8 model need to consider scales
if (is_int8_) {
  float input_scale = net_info_->input_scales[0];
  linear_trans_param_.alpha_0 = input_scale;
  linear_trans_param_.beta_0 = -123.0 * input_scale;
  linear_trans_param_.alpha_1 = input_scale;
  linear_trans_param_.beta_1 = -117.0 * input_scale;
  linear_trans_param_.alpha_2 = input_scale;
  linear_trans_param_.beta_2 = -104.0 * input_scale;
}
...
```

其中input\_scale是INT8模型量化之后得到的参数，需要乘到每个像素，而FP32情况下就不再需要。 以上就是初始化的流程。接下来是输入的处理过程，这个示例算法同时支持图片和视频作为输入，在main.cpp的main()函数中，我们以视频为例，详细的写法：

### **4.2.2.2 打开视频流**

```cpp
...
// open stream
cv::VideoCapture cap(input_url);
if (!cap.isOpened()) {
  cout << "open stream " << input_url << " failed!" << endl;
  exit(1);
}

// get resolution
int w = int(cap.get(cv::CAP_PROP_FRAME_WIDTH));
int h = int(cap.get(cv::CAP_PROP_FRAME_HEIGHT));
cout << "resolution of input stream: " << h << "," << w << endl;

// set output format to YUVi420
cap.set(cv::CAP_PROP_OUTPUT_YUV, 1.0);
...
```

除了最下面的cap.set()调用，上面这段代码和标准的opencv处理视频流程几乎相同。cap.set()调用会将解码帧的格式配置成YUV I420，一般我们会推荐使用YUV 格式作为缓存原始帧的格式，对比BGR格式，YUV格式既可以加速预处理流程，又可以减少内存消耗，是一个非常重要的优化。

### **4.2.2.3 解码视频帧**

```cpp
...
// get one mat 
cap.read(*p_img);

// sanity check
if (p_img->avRows() != h || p_img->avCols() != w) {
  if (p_img != nullptr) delete p_img;
  continue;
}
...
```

当解码一帧图像，我们需要检查他的尺寸是否正确，对于YUV格式的Mat对象，我们通过avRows()和avCols()接口获取宽高。

### **4.2.2.4 Mat 转换 bm\_image**&#x20;

获取了解码后的视频帧，需要转换到bm\_image对象，因为BMCV预处理接口和网络推理接口都需要使用bm\_image对象作为输入。在推理完成之后，直接使用bm\_image\_destroy()接口进行释放。需要注意的是，这个转换过程没有发生内存拷贝。

```cpp
...
bm_image_from_mat(bm_handle, images, input_img_bmcv);
...
for (size_t i = 0; i < input_img_bmcv.size();i++) {
  bm_image_destroy (input_img_bmcv[i]);
}
...
```

### **4.2.2.5 预处理**&#x20;

bmcv\_image\_vpp\_convert()函数将resize / crop / yuv to bgr / split(transpose) 三个操作组合在了一个调用完成，是预处理过程加速的关键。 bmcv\_convert\_to()函数用于进行线性变换，使用的参数linear\_trans\_param在初始化阶段已经配置完成。

```cpp
...
// set input shape according to input bm images
input_shape_ = {4, {(int)input.size(), 3, INPUT_HEIGHT, INPUT_WIDTH}};

// do not crop
crop_rect_ = {0, 0, input[0].width, input[0].height};

// resize && split by bmcv
for (size_t i = 0; i < input.size(); i++) {
  LOG_TS(ts_, "ssd pre-process-vpp")
  bmcv_image_vpp_convert (bm_handle_, 1, input[i], &resize_bmcv_[i], &crop_rect_);
  LOG_TS(ts_, "ssd pre-process-vpp")
}

// do linear transform
LOG_TS(ts_, "ssd pre-process-linear_tranform")
bmcv_convert_to (bm_handle_, input.size(), linear_trans_param_, resize_bmcv_, linear_trans_bmcv_);
LOG_TS(ts_, "ssd pre-process-linear_tranform")
...
```

## **4.2.3 推理**

推理过程的input是预处理过程的output：linear\_trans\_bmcv，这个bm\_image对象是在初始化的时候就创建的物理连续内存。 推理需要指定input shape和model name，如果目标模型不支持指定的input shape，bm\_inference()调用将会失败。

```cpp
...
bool res = bm_inference (p_bmrt_, linear_trans_bmcv_, (void*)output_, input_shape_, model_name);
...
```

## 4.2.4 后处理

后处理的过程因模型而异，而且大部分是cpu执行的代码，就不再这里赘述。需要注意的是我们在BMCV中也提供了一些可以用于加速的接口，如bmcv\__sort、bmcv\__nms等，对于其他需要使用硬件加速的情况，可根据需要使用OKKernel(TPUKernel)开发。

以上就是SSD样例的简单描述，关于涉及到的接口的更详细描述，请查看相应模块文档。

## 4.2.5 算法开发注意事项汇总

根据上面的讨论，我们把一些注意事项汇总如下：

视频解码需要注意：

{% hint style="info" %}
1. 通过cap.set()接口设置YUV格式。
2. YUV格式的Mat，其宽高从cols和rows变成avCols()和avRows()。
{% endhint %}

预处理过程需要注意：

{% hint style="info" %}
1. 预处理操作对象是bm\_image，bm\_image对象可以类比Mat对象。
2. 预处理流程中scale缩放是针对int8模型。在推理数据输入前需要乘scale系数。scale系数是在量化的过程中产生。
3. 为多个bm\_image对象申请连续物理内存：bm\_image\_create\_batch()。
4. resize默认双线性插值算法，具体参考bmcv\_image\_vpp\_convert接口说明。
{% endhint %}

推理过程需要注意：

{% hint style="info" %}
1. 网络名称用于选择目标模型，需要在编译阶段就进行指定
2. 调用推理接口的时候，input\_shape要和bm\_image匹配(n, c, h, w)
3. 推荐使用4batch优化性能
{% endhint %}
