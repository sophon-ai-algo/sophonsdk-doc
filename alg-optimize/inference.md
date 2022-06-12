# 4.6 模型推理

C接口详细介绍请阅读[《NNToolChain用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/index.html)中的[BMRuntime使用章节](https://doc.sophgo.com/docs/docs\_latest\_release/nntc/html/usage/runtime.html)。

​Python接口详细介绍请阅读[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。

​BMRuntime用于读取BMCompiler的编译输出(.bmodel)，驱动其在Sophon TPU芯片中执行。BMRuntime向用户提供了丰富的接口，便于用户移植算法，其软件架构如下:

![](<../.gitbook/assets/1 (4).png>)

BMRuntime实现了C/C++接口，SAIL模块基于对BMRuntime和BMLib的封装实现了Python接口。本章主要介绍C和Python常用接口，主要内容如下：

* BMLib 接口：负责设备Handle的管理、内存管理、数据搬运、API的发送和同步、A53使能、设置TPU工作频率等
* BMRuntime的C语言接口
* BMLib和BMRuntime的Python接口介绍

## 4.6.1 BMLib模块C接口介绍

### BMLIB接口

*   用于设备管理，不属于BMRuntime，但需要配合使用，所以先介绍

    BMLIB接口是C语言接口，对应的头文件是bmlib\_runtime.h，对应的lib库为libbmlib.so,

    BMLIB接口用于设备管理，包括设备内存的管理。

    BMLIB的接口很多，这里介绍应用程序通常需要用到的接口。
*   **bm\_dev\_request**

    用于请求一个设备，得到设备句柄handle。其他设备接口，都需要指定这个设备句柄。

    其中devid表示设备号，在PCIE模式下，存在多个设备时可以用于选择对应的设备；在SoC模式下，请指定为0。

```cpp
/**
 * @name    bm_dev_request
 * @brief   To create a handle for the given device
 * @ingroup bmlib_runtime
 *
 * @param [out] handle  The created handle
 * @param [in]  devid   Specify on which device to create handle
 * @retval  BM_SUCCESS  Succeeds.
 *          Other code  Fails.
 */
bm_status_t bm_dev_request(bm_handle_t *handle, int devid);
```

*   **bm\_dev\_free**

    用于释放一个设备。通常应用程序开始需要请求一个设备，退出前释放这个设备。

```cpp
/**
 * @name    bm_dev_free
 * @brief   To free a handle
 * @param [in] handle  The handle to free
 */
void bm_dev_free(bm_handle_t handle);
```

## 4.6.2 BMRuntime模块C接口介绍

对应的头文件为bmruntime\_interface.h，对应的lib库为libbmrt.so。

用户程序使用C接口时建议使用该接口，该接口支持多种shape的静态编译网络，支持动态编译网络。

* **bmrt\_create**

```cpp
/**
 * @name    bmrt_create
 * @brief   To create the bmruntime with bm_handle.
 * This API creates the bmruntime. It returns a void* pointer which is the pointer
 * of bmruntime. Device id is set when get bm_handle;
 * @param [in] bm_handle     bm handle. It must be initialized by using bmlib.
 * @retval void* the pointer of bmruntime
 */
void* bmrt_create(bm_handle_t bm_handle);
```

* **bmrt\_destroy**

```cpp
/**
 * @name    bmrt_destroy
 * @brief   To destroy the bmruntime pointer
 * @ingroup bmruntime
 * This API destroy the bmruntime.
 * @param [in]     p_bmrt        Bmruntime that had been created
 */
void bmrt_destroy(void* p_bmrt);
```

*   **bmrt\_load\_bmodel**

    加载bmodel文件，加载后bmruntime中就会存在若干网络的数据，后续可以对网络进行推理。

```cpp
/**
 * @name    bmrt_load_bmodel
 * @brief   To load the bmodel which is created by BM compiler
 * This API is to load bmodel created by BM compiler.
 * After loading bmodel, we can run the inference of neuron network.
 * @param   [in]   p_bmrt        Bmruntime that had been created
 * @param   [in]   bmodel_path   Bmodel file directory.
 * @retval true    Load context sucess.
 * @retval false   Load context failed.
 */
bool bmrt_load_bmodel(void* p_bmrt, const char *bmodel_path);
```

*   **bmrt\_load\_bmodel\_data**

    加载bmodel，不同于bmrt\_load\_bmodel，它的bmodel数据存在内存中

```cpp
/*
  Parameters: [in] p_bmrt      - Bmruntime that had been created.
              [in] bmodel_data - Bmodel data pointer to buffer.
              [in] size        - Bmodel data size.
  Returns:    bool             - true: success; false: failed.
  */
  bool bmrt_load_bmodel_data(void* p_bmrt, const void * bmodel_data, size_t size);
```

*   **bmrt\_get\_network\_info**

    bmrt\_get\_network\_info根据网络名，得到某个网络的信息

```cpp
/* bm_stage_info_t holds input shapes and output shapes;
every network can contain one or more stages */
typedef struct {
  bm_shape_t* input_shapes;   /* input_shapes[0] / [1] / ... / [input_num-1] */
  bm_shape_t* output_shapes;  /* output_shapes[0] / [1] / ... / [output_num-1] */
} bm_stage_info_t;

/* bm_tensor_info_t holds all information of one net */
typedef struct {
  const char* name;              /* net name */
  bool is_dynamic;               /* dynamic or static */
  int input_num;                 /* number of inputs */
  char const** input_names;      /* input_names[0] / [1] / .../ [input_num-1] */
  bm_data_type_t* input_dtypes;  /* input_dtypes[0] / [1] / .../ [input_num-1] */
  float* input_scales;           /* input_scales[0] / [1] / .../ [input_num-1] */
  int output_num;                /* number of outputs */
  char const** output_names;     /* output_names[0] / [1] / .../ [output_num-1] */
  bm_data_type_t* output_dtypes; /* output_dtypes[0] / [1] / .../ [output_num-1] */
  float* output_scales;          /* output_scales[0] / [1] / .../ [output_num-1] */
  int stage_num;                 /* number of stages */
  bm_stage_info_t* stages;       /* stages[0] / [1] / ... / [stage_num-1] */
} bm_net_info_t;
```

bm\_net\_info\_t表示一个网络的全部信息，bm\_stage\_info\_t表示该网络支持的不同的shape情况。

```cpp
/**
 * @name    bmrt_get_network_info
 * @brief   To get network info by net name
 * @param [in]     p_bmrt         Bmruntime that had been created
 * @param [in]     net_name       Network name
 * @retval  bm_net_info_t*        Pointer to net info, needn't free by user; if net name not found, will return NULL.
 */
const bm_net_info_t* bmrt_get_network_info(void* p_bmrt, const char* net_name);
```

示例代码：

```cpp
const char *model_name = "VGG_VOC0712_SSD_300X300_deploy"
const char **net_names = NULL;
bm_handle_t bm_handle;
bm_dev_request(&bm_handle, 0);
void * p_bmrt = bmrt_create(bm_handle);
bool ret = bmrt_load_bmodel(p_bmrt, bmodel.c_str());
std::string bmodel; //bmodel file
int net_num = bmrt_get_network_number(p_bmrt, model_name);
bmrt_get_network_names(p_bmrt, &net_names);
for (int i=0; i<net_num; i++) {
  //do somthing here
  ......
}
free(net_names);
bmrt_destroy(p_bmrt);
bm_dev_free(bm_handle);
```

*   **bmrt\_shape\_count**

    接口声明如下：

```cpp
/*
number of shape elements, shape should not be NULL and num_dims should not large than BM_MAX_DIMS_NUM 
*/
uint64_t bmrt_shape_count(const bm_shape_t* shape);
```

可以得到shape的元素个数。

比如num\_dims为4，则得到的个数为dims\[0]\*dims\[1]\*dims\[2]\*dims\[3]

bm\_shape\_t 结构介绍：

```cpp
typedef struct {
  int num_dims;
  int dims[BM_MAX_DIMS_NUM];
} bm_shape_t;
```

bm\_shape\_t表示tensor的shape，目前最大支持8维的tensor。其中num\_dims为tensor的实际维度数，dims为各维度值，dims的各维度值从\[0]开始，比如(n, c, h, w)四维分别对应(dims\[0], dims\[1], dims\[2], dims\[3])。

如果是常量shape，初始化参考如下：

```cpp
bm_shape_t shape = {4, {4,3,228,228}};
bm_shape_t shape_array[2] = {
  {4, {4,3,28,28}}, // [0]
  {2, {2,4}}, // [1]
}
```

* **bm\_image\_from\_mat**

```cpp
//if use this function you need to open USE_OPENCV macro in include/bmruntime/bm_wrapper.hpp
/**
 * @name    bm_image_from_mat
 * @brief   Convert opencv Mat object to BMCV bm_image object
 * @param [in]     in          OPENCV mat object
 * @param [out]    out         BMCV bm_image object
 * @retval true    Launch success.
 * @retval false   Launch failed.
 */
 static inline bool bm_image_from_mat (cv::Mat &in, bm_image &out)
```

```cpp
//* @brief   Convert opencv multi Mat object to multi BMCV bm_image object
static inline bool bm_image_from_mat (std::vector<cv::Mat> &in, std::vector<bm_image> &out)
```

* **bm\_image\_from\_frame**

```cpp
/**
 * @name    bm_image_from_frame
 * @brief   Convert ffmpeg a avframe object to a BMCV bm_image object
 * @ingroup bmruntime
 *
 * @param [in]     bm_handle   the low level device handle
 * @param [in]     in          a read-only avframe
 * @param [out]    out         an uninitialized BMCV bm_image object
                     use bm_image_destroy function to free out parameter until                              you no longer useing it.
 * @retval true    change success.
 * @retval false   change failed.
 */

static inline bool bm_image_from_frame (bm_handle_t       &bm_handle,
                                      AVFrame           &in,
                                      bm_image          &out)
```

```cpp
/**
 * @name    bm_image_from_frame
 * @brief   Convert ffmpeg avframe  to BMCV bm_image object
 * @ingroup bmruntime
 *
 * @param [in]     bm_handle   the low level device handle
 * @param [in]     in          a read-only ffmpeg avframe vector
 * @param [out]    out         an uninitialized BMCV bm_image vector
                   use bm_image_destroy function to free out parameter until                              you no longer useing it.
 * @retval true    change success.
 * @retval false   chaneg failed.
 */
static inline bool bm_image_from_frame (bm_handle_t                &bm_handle,
                                      std::vector<AVFrame>       &in,
                                      std::vector<bm_image>      &out)
```

* **bm\_inference**

```cpp
//if use this function you need to open USE_OPENCV macro in include/bmruntime/bm_wrapper.hpp
/**
 * @name    bm_inference
 * @brief   A block inference wrapper call
 * @ingroup bmruntime
 *
 * This API supports the neuron nework that is static-compiled or dynamic-compiled
 * After calling this API, inference on TPU is launched. And the CPU
 * program will be blocked.
 * This API support single input && single output, and multi thread safety
 *
 * @param [in]    p_bmrt         Bmruntime that had been created
 * @param [in]    input          bm_image of single-input data
 * @param [in]    output         Pointer of  single-output buffer
 * @param [in]    net_name       The name of the neuron network
 * @param [in]    input_shape    single-input shape
 *
 * @retval true    Launch success.
 * @retval false   Launch failed.
 */
static inline bool bm_inference (void           *p_bmrt,
                                 bm_image        *input,
                                 void           *output,
                                 bm_shape_t input_shape,
                                 const char   *net_name)
```

```cpp
// * This API support single input && multi output, and multi thread safety
static inline bool bm_inference (void                       *p_bmrt,
                                 bm_image                    *input,
                                 std::vector<void*>         outputs,
                                 bm_shape_t             input_shape,
                                 const char               *net_name)
```

```cpp
// * This API support multiple inputs && multiple outputs, and multi thread safety
static inline bool bm_inference (void                           *p_bmrt,
                                 std::vector<bm_image*>          inputs,
                                 std::vector<void*>             outputs,
                                 std::vector<bm_shape_t>   input_shapes,
                                 const char                   *net_name)
```

## 4.6.3 Python接口

本章节只介绍了用例examples/simple/ssd/python/py\_ffmpeg\_bmcv\_sail下的例子中所用的接口函数。

更多接口定义请查阅[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。

* **Engine**

```python
def __init__(tpu_id):
""" Constructor does not load bmodel.
Parameters 
---------
tpu_id : int TPU ID. You can use bm-smi to see available IDs 
"""
```

* **load**

```python
def load(bmodel_path):
Load bmodel from file.
Parameters 
---------
bmodel_path : str Path to bmode
"""
```

* **set\_io\_mode**

```python
def set_io_mode(mode):
""" Set IOMode for a graph.
Parameters 
---------
mode : sail.IOMode Specified io mode 
"""
```

* **get\_graph\_names**

```python
def get_graph_names(): 
""" Get all graph names in the loaded bmodels.
Returns 
------
graph_names : list Graph names list in loaded context 
"""
```

* **get\_input\_names**

```python
def get_input_names(graph_name): 
""" Get all input tensor names of the specified graph.
Parameters 
---------
graph_name : str Specified graph name
Returns 
------
input_names : list All the input tensor names of the graph 
"""
```

* **get\_output\_names**

```python
def get_output_names(graph_name):
""" Get all output tensor names of the specified graph.
Parameters
---------
graph_name : str Specified graph name
Returns 
------
input_names : list All the output tensor names of the graph 
"""
```

* **sail.IOMode**

```python
# Input tensors are in system memory while output tensors are in device memory sail.IOMode.SYSI
# Input tensors are in device memory while output tensors are in system memory. 
sail.IOMode.SYSO 
# Both input and output tensors are in system memory. 
sail.IOMode.SYSIO 
# Both input and output tensors are in device memory. 
ail.IOMode.DEVIO
```

* **set\_io\_mode**

```python
def set_io_mode(mode):
""" Set IOMode for a graph.
Parameters 
---------
mode : sail.IOMode Specified io mode 
"""
```

* **sail.Tensor**

```python
def __init__(handle, shape, dtype, own_sys_data, own_dev_data):
""" Constructor allocates system memory and device memory of the tensor.
Parameters 
---------
handle : sail.Handle Handle instance 
shape : tuple Tensor shape 
dytpe : sail.Dtype Data type 
own_sys_data : bool Indicator of whether own system memory 
own_dev_data : bool Indicator of whether own device memory 
"""
```

* **get\_input\_dtype**

```python
def get_input_dtype(graph_name, tensor_name):
""" Get scale of an input tensor. Only used for int8 models.
Parameters 
---------
graph_name : str The specified graph name tensor_name : str The specified output tensor name
Returns 
------
scale: sail.Dtype Data type of the input tensor 
"""
```

* **get\_output\_dtype**

```python
def get_output_dtype(graph_name, tensor_name):
""" Get the shape of an output tensor in a graph.
Parameters 
---------
graph_name : str The specified graph name tensor_name : str The specified output tensor name
Returns 
------
tensor_shape : list The shape of the tensor 
"""
```

* **process**

```python
def process(graph_name, input_tensors, output_tensors):
""" Inference with provided input and output tensors.
Parameters 
---------
graph_name : str The specified graph name 
input_tensors : dict {str : sail.Tensor} Input tensors managed by user 
output_tensors : dict {str : sail.Tensor} Output tensors managed by user 
"""
```

* **get\_input\_scale**

```python
def get_input_scale(graph_name, tensor_name):
""" Get scale of an input tensor. Only used for int8 models.
Parameters 
---------
graph_name : str The specified graph name tensor_name : str The specified output tensor name
Returns 
------
scale: float32 Scale of the input tensor 
"""
```
