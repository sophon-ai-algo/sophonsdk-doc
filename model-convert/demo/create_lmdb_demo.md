# 3.4.1 create\_lmdb\_demo

create\_lmdb\_demo位于：${BMNNSDK}/examples/calibration/create\_lmdb\_demo

{% hint style="warning" %}
注意：BMNNSDK2.7.0 删除了原来的convert\_imageset命令行工具。
{% endhint %}

该用例将jpg图片转换成lmdb数据集，使用示例的代码可以将指定目录下的图片转换后存入lmdb中，用户可以修改此示例代码添加自己的前处理操作。

```python
from logging import raiseExceptions
from re import I
import cv2
import os
import sys
from ufw.io import *
import random
import numpy as np
import argparse

def convertString2Bool(str):
    if str.lower() in {'true'}:
        return True
    elif str.lower() in {'false'}:
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected')

def expand_path(args):
    if args.imageset_rootfolder != '':
        args.imageset_rootfolder = os.path.realpath(args.imageset_rootfolder)
    if args.imageset_lmdbfolder != '':
        args.imageset_lmdbfolder = os.path.realpath(args.imageset_lmdbfolder)
    else:
        args.imageset_lmdbfolder = args.imageset_rootfolder

def gen_imagelist(args):
    pic_path = args.imageset_rootfolder
    print(pic_path)
    file_list = []
    dir_or_files = os.listdir(pic_path)
    for dir_file in dir_or_files:
        dir_file_path = os.path.join(pic_path,dir_file)
        ext_name = os.path.splitext(dir_file)[-1]
        if not os.path.isdir(dir_file_path) and ext_name in ['.jpg','.png','.jpeg','.bmp','.JPEG','.JPG','.BMP']:
            file_list.append(dir_file_path)
            print(dir_file_path)
    if len(file_list) == 0:
        print(pic_path+' no pictures')
        exit(1)

    if args.shuffle:
        random.seed(3)
        random.shuffle(file_list)

    return file_list

def read_image_to_cvmat(image_path, height, width, is_gray):
    print(image_path)
    cv_read_flag = cv2.IMREAD_GRAYSCALE if is_gray else cv2.IMREAD_COLOR
    cv_img_origin = cv2.imread(image_path.strip(), cv_read_flag)

    if is_gray:
        h, w = cv_img_origin.shape
    else:
        h, w, c = cv_img_origin.shape
    print("original shape:", cv_img_origin.shape)
    
    if height == 0:
        height = h
    
    if width == 0:
        width = w
    
    cv_img = cv2.resize(cv_img_origin, (width, height))
    

    print("read image resized dimensions:", cv_img.shape)
    print(type(cv_img))
    return cv_img

if __name__ == '__main__':
    parse = argparse.ArgumentParser(description='convert imageset')
    parse.add_argument('--imageset_rootfolder', type=str, required=True, help = 'please setting images source path')
    parse.add_argument('--imageset_lmdbfolder', type=str, default='', help = 'please setting lmdb path')
    parse.add_argument('--shuffle', type=convertString2Bool, default=False, help = 'shuffle order of images')
    parse.add_argument('--resize_height', type=int, default=0, help = 'target height')
    parse.add_argument('--resize_width', type=int, default=0, help = 'target width')
    parse.add_argument('--bgr2rgb', type=convertString2Bool, default=False, help = 'convert bgr to rgb')
    parse.add_argument('--gray', type=convertString2Bool, default=False, help='if True, read image as gray')
    args = parse.parse_args()

    expand_path(args)
    image_list = gen_imagelist(args)

    lmdb = LMDB_Dataset(args.imageset_lmdbfolder)
    for image_path in image_list:
        cv_img = read_image_to_cvmat(image_path, args.resize_height, args.resize_width, args.gray)
        print("cv_imge after resize", cv_img.shape)
        if args.bgr2rgb:
            cv_img = cv2.cvtColor(cv_img, cv2.COLOR_BGR2RGB)
            print("cv_imge after bgr2rgb", cv_img.shape)

        if args.gray:
            cv_img = np.expand_dims(cv_img,2)
            print("gray dimension", cv_img.shape)

        cv_img = cv_img.transpose([2,0,1])

        lmdb.put(np.ascontiguousarray(cv_img, dtype=np.float32))

        print("save lmdb once")

    lmdb.close()
```

运行完毕，结果如下所示。

```bash
# 切换到demo目录
cd <release dir>/examples/calibration/create_lmdb_demo
$ python3 convert_imageset.py \
   --imageset_rootfolder=./images \
   --imageset_lmdbfolder=./images \
   --resize_height=256 \
   --resize_width=256 \
   --shuffle=True \
   --bgr2rgb=False \
   --gray=False
```

运行完毕，命令行输出如下所示：

```bash
original shape: (323, 481, 3)
read image resized dimensions: (256, 256, 3)
<class 'numpy.ndarray'>
cv_imge after resize (256, 256, 3)
save lmdb once
/sdk/examples/create_lmdb_demo/images/cat_gray.jpg
original shape: (360, 480, 3)
read image resized dimensions: (256, 256, 3)
<class 'numpy.ndarray'>
cv_imge after resize (256, 256, 3)
save lmdb once
/sdk/examples/create_lmdb_demo/images/cat.jpg
original shape: (360, 480, 3)
read image resized dimensions: (256, 256, 3)
<class 'numpy.ndarray'>
cv_imge after resize (256, 256, 3)
save lmdb once
/sdk/examples/create_lmdb_demo/images/cat gray.jpg
original shape: (360, 480, 3)
read image resized dimensions: (256, 256, 3)
<class 'numpy.ndarray'>
cv_imge after resize (256, 256, 3)
save lmdb once
```

使用tree命令查看images文件夹内容：

```bash
tree images

# 以下为命令行输出
images/
|-- cat\ gray.jpg
|-- cat.jpg
|-- cat_gray.jpg
|-- data.mdb
`-- fish-bike.jpg
```

其中的images/data.mdb就是生成的lmdb数据集。用户可以参考此示例生成模型对应的数据集合。

使用如下命令查看lmdb文件的信息：

```
python3 -m ufwio.lmdb_info images/
```

输出结果如下：

```bash
       # terminal outputs
                         Name,     DType,  Shape,  Data
       0000000000__ ,   float32,  (1, 3, 256, 256),  [ 26.  26.  29. ... 217. 210. 184.]
       0000000001__ ,   float32,  (1, 3, 256, 256),  [ 26.  26.  29. ... 217. 210. 184.]
       0000000002__ ,   float32,  (1, 3, 256, 256),  [ 50.  47.  50. ... 216. 210. 185.]
       0000000003__ ,   float32,  (1, 3, 256, 256),  [ 82.  91.  89. ... 206. 203. 207.]
```
