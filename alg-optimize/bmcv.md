# 4.5 图形运算加速模块

BMCV提供了一套基于算丰AI芯片优化的机器视觉库，目前可以完成色彩空间转换、尺度变换、仿射变换、投射变换、线性变换、画框、JPEG编码、BASE64编码、NMS、排序、特征匹配等操作。关于BMCV模块详细内容请阅读[《BMCV用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/bmcv/html/index.html)。

​ Python接口的实现请参考[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。

​BMCV API均是围绕bm\_image来进行的。一个bm\_image结构对应于一张图片。

## 4.5.1 C语言编程接口

### **bm\_image结构体**

```cpp
struct bm_image {
    int width;
    int height;
    bm_image_format_ext image_format;
    bm_data_format_ext data_type;
    bm_image_private* image_private;
};
```

bm\_image 结构成员包括图片的宽高，图片格式，图片数据格式，以及该结构的私有数据。

关于bm\_image初始化，我们不建议用户直接填充bm\_image结构使用，而是通过以下API来创建/销毁一个bm\_image结构

### **图片格式 image\_format枚举类型**

```cpp
typedef enum bm_image_format_ext_{
    FORMAT_YUV420P,
    FORMAT_NV12,
    FORMAT_NV21,
    FORMAT_NV16,
    FORMAT_NV61,
    FORMAT_RGB_PLANAR,
    FORMAT_BGR_PLANAR,
    FORMAT_RGB_PACKED,
    FORMAT_BGR_PACKED,
    FORMAT_GRAY,
    FORMAT_COMPRESSED
}bm_image_format_ext;
```

| 格式                  | 说明                               |
| ------------------- | -------------------------------- |
| FORMAT\_YUV420P     | 表示预创建一个YUV420格式的图片，有三个plane      |
| FORMAT\_NV12        | 表示预创建一个NV12格式的图片，有两个plane        |
| FORMAT\_NV21        | 表示预创建一个NV21格式的图片，有两个plane        |
| FORMAT\_RGB\_PLANAR | 表示预创建一个RGB格式的图片，RGB分开排列，有一个plane |
| FORMAT\_BGR\_PLANAR | 表示预创建一个BGR格式的图片，BGR分开排列，有一个plane |
| FORMAT\_RGB\_PACKED | 表示预创建一个RGB格式的图片，RGB交错排列，有一个plane |
| FORMAT\_BGR\_PACKED | 表示预创建一个BGR格式的图片，BGR交错排列，有一个plane |
| FORMAT\_GRAY        | 表示预创建一个灰度图格式的图片，有一个plane         |
| FORMAT\_COMPRESSED  | 表示预创建一个VPU内部压缩格式的图片，有四个plane     |

### **数据存储格式枚举**

```cpp
typedef enum bm_image_data_format_ext_{
    DATA_TYPE_EXT_FLOAT32,
    DATA_TYPE_EXT_1N_BYTE,
    DATA_TYPE_EXT_4N_BYTE,
    DATA_TYPE_EXT_1N_BYTE_SIGNED,
    DATA_TYPE_EXT_4N_BYTE_SIGNED,
}bm_image_data_format_ext;
```

| 数据格式                              | 说明                                      |
| --------------------------------- | --------------------------------------- |
| DATA\_TYPE\_EXT\_FLOAT32          | 表示所创建的图片数据格式为单精度浮点数                     |
| DATA\_TYPE\_EXT\_1N\_BYTE         | 表示所创建图片数据格式为普通带符号1N INT8                |
| DATA\_TYPE\_EXT\_4N\_BYTE         | 表示所创建图片数据格式为4N INT8，即四张带符号INT8图片数据交错排列  |
| DATA\_TYPE\_EXT\_1N\_BYTE\_SIGNED | 表示所创建图片数据格式为普通无符号1N UINT8               |
| DATA\_TYPE\_EXT\_4N\_BYTE         | 表示所创建图片数据格式为4N UINT8，即四张无符号INT8图片数据交错排列 |

​ 关于bm\_image初始化，我们不建议用户直接填充bm\_image结构使用，而是通过以下API来创建/销毁一个bm\_image结构

*   **bm\_image\_create\_batch**

    创建物理内存连续的多个bm image。

```cpp
 /*
 * @param [in]     handle       handle of low level device             
 * @param [in]     img_h        image height                 
 * @param [in]     img_w        image width
 * @param [in]     img_format   format of image: BGR or YUV
 * @param [in]     data_type    data type of image: INT8 or FP32 
 * @param [out]    image        pointer of bm image object
 * @param [in]     batch_num    batch size
 */
 static inline bool bm_image_create_batch (bm_handle_t              handle,  
                                          int                      img_h,  
                                        int                      img_w,    
                                          bm_image_format_ext      img_format,
                                        bm_image_data_format_ext data_type,  
                                          bm_image                 *image, 
                                          int                      batch_num)
```

*   **bm\_image\_destroy\_batch**

    释放物理内存连续的多个bm image。要和bm\_image\_create\_batch接口成对使用。

```cpp
/*
* @param [in]     image        pointer of bm image object
* @param [in]     batch_num    batch size
*/
static inline bool bm_image_destroy_batch (bm_image *image, int batch_num)
```

*   **bm\_image\_alloc\_contiguous\_mem**

    为多个 image 分配连续的内存

```cpp
bm_status_t bm_image_alloc_contiguous_mem(
                int image_num,
                bm_image *images,
                int bmcv_image_usage
);
```

| 参数                     | 说明                                          |
| ---------------------- | ------------------------------------------- |
| int image\_num         | 待分配内存的 image 个数                             |
| bm\_image \*images     | 待分配内存的 image 的指针                            |
| int bmcv\_image\_usage | 已经为客户默认设置了参数，（如果客户对于所分配内存位置有要求，可以通过该参数进行制定） |

*   **bm\_image\_free\_contiguous\_mem**

    释放通过bm\_image\_alloc\_contiguous\_mem申请的内存

```cpp
bm_status_t bm_image_free_contiguous_mem(
                int image_num,
                bm_image *images
        );
```

| 参数                 | 说明               |
| ------------------ | ---------------- |
| int image\_num     | 待分配内存的 image 个数  |
| bm\_image \*images | 待分配内存的 image 的指针 |

*   **bmcv\_image\_vpp\_convert**

    bm1684上有专门的视频后处理硬件，满足一定条件下可以一次实现**csc + crop + resize**功能，速度比TPU更快。

```cpp
bmcv_image_vpp_convert(
bm_handle_t           handle,
      int                   output_num,
      bm_image              input,
      bm_image *            output,
      bmcv_rect_t *         crop_rect,
      bmcv_resize_algorithm algorithm = BMCV_INTER_LINEAR);
```

该API将输入图像格式转化为输出图像格式，并支持crop + resize功能， 支持从1张输入中crop多张输出并resize到输出图片大小。

| 参数                                                       | 说明                                                                                    |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| bm\_handle\_t handle                                     | 设备环境句柄，通过调用bm\_dev\_request获取                                                         |
| int output\_num                                          | 输出 bm\_image 数量，和src image的crop 数量相等,一个src crop 输出一个dst bm\_image                     |
| bm\_image input                                          | 输入bm\_image对象                                                                         |
| bm\_image\* output                                       | 输出bm\_image对象指针                                                                       |
| bmcv\_rect\_t \*  crop\_rect                             | 每个输出bm\_image对象所对应的在输入图像上crop的参数，包括起始点x坐标、起始点y坐标、crop图像的宽度以及crop图像的高度，具体请查看BMCV用户开发手册 |
| bmcv\_resize\_algorithm algorithm = BMCV\_INTER\_LINEAR) | resize算法选择，包括 BMCV\_INTER\_NEAREST 和 BMCV\_INTER\_LINEAR 两种，默认情况下是双线性差值               |

*   **bmcv\_convert\_to**

    实现图像像素线性变化，具体数据关系可用公式表示

$$
y= α*x+ β
$$

```cpp
bm_status_t bmcv_convert_to (bm_handle_t handle,int input_num,
                        bmcv_convert_to_attr convert_to_attr, 
                        bm_image* input, bm_image* output)
```

| 参数                                        | 说明                                                                                                                                                                    |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| bm\_handle\_thandle                       | 输入的bm\_handle句柄                                                                                                                                                       |
| int    input\_num                         | 输入图片数。最多支持4                                                                                                                                                           |
| bmcv\_convert\_to\_attr convert\_to\_attr | 每张图片对应的配置参数                                                                                                                                                           |
| bm\_image\* input                         | 输入bm\_image。每个bm\_image外部需要调用bmcv\_image\_create创建。image内存可以使用bmcv\_image\_dev\_mem\_alloc或者bmcv\_image\_copy\_to\_device来开辟新的内存，或者使用bmcv\_image\_attach来attach已有的内存。 |
| bm\_image\*output                         | 输出bm\_image。每个bm\_image外部需要调用bmcv\_image\_create创建。image内存可以通过bmcv\_image\_dev\_mem\_alloc来开辟新的内存，或者使用bmcv\_image\_attach来attach已有的内存。如果不主动分配将在api内部进行自行分配            |

结构体**bmcv\_convert\_to\_attr\_s**

```cpp
typedef struct bmcv_convert_to_attr_s {
    float alpha_0;                 
    float beta_0;  
    float alpha_1;
    float beta_1;
    float alpha_2;
    float beta_2;
} bmcv_convert_to_attr;
```

| 参数       | 说明                     |
| -------- | ---------------------- |
| alpha\_0 | 描述了第0个channel进行线性变换的系数 |
| beta\_0  | 描述了第0个channel进行线性变换的偏移 |
| alpha\_1 | 描述了第1个channel进行线性变换的系数 |
| beta\_1  | 描述了第1个channel进行线性变换的偏移 |
| alpha\_2 | 描述了第2个channel进行线性变换的系数 |
| beta\_2  | 描述了第2个channel进行线性变换的偏移 |

结构体描述了三通道中的alpha和beta。实际要根据推理的输入数据是几通道来进行参数配置。

## 4.5.2 Python语言编程接口

本章节只介绍了用例py\_ffmpeg\_bmcv\_sail中用的的接口函数

更多接口定义请查阅[《SAIL用户开发手册》](https://doc.sophgo.com/docs/docs\_latest\_release/sophon-inference/html/index.html)。

* **init**

```python
def __init__(handle): 
""" Constructor.
Parameters 
---------
handle : sail.Handle Handle instance 
"""
```

* **tensor\_to\_bm\_image**

```python
def tensor_to_bm_image(tensor): 
""" Convert tensor to image.
Parameters 
---------
tensor : sail.Tensor Tensor instance
Returns 
------
image : sail.BMImage BMImage instance 
"""
```

* **convert\_to**

```python
def convert_to(input, alpha_beta): 
""" Applies a linear transformation to an image.
Parameters
---------
input : sail.BMImage Input image 
alpha_beta: tuple (a0, b0), (a1, b1), (a2, b2) factors
Returns 
---------
output : sail.BMImage Output image 
"""
```

* **vpp\_resize**

```python
def vpp_resize(input, resize_w, resize_h): 
""" Resize an image with interpolation of INTER_NEAREST using vpp.
Parameters 
---------
input : sail.BMImage Input image 
resize_w : int Target width 
resize_h : int Target height
Returns 
---------
output : sail.BMImage Output image 
"""
```
