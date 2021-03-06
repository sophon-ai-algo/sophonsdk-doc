# 5.2 PCIE加速卡模式

#### 5.2.1 下载基础镜像：[bmnnsdk2-bm1684-ubuntu.docker](https://developer.sophgo.com/site/index/material/11/all.html)

#### 5.2.2 构建自定义镜像

Dockerfile示例（仅供参考）：Dockerfile.x86

{% file src="../.gitbook/assets/Dockerfile.x86" %}

```docker
# 指定基础镜像
FROM bmnnsdk2-bm1684/dev:ubuntu16.04

# 维护者信息
MAINTAINER docker_user docker_user@email.com

# 安装基本软件包
RUN apt-get update --fix-missing \
 && apt-get install -y gcc vim libglib2.0-dev \
 && apt-get -y install locales

# 设置时区
ENV TIME_ZONE Asia/Shanghai
RUN apt-get install -y tzdata \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# 安装nginx/redis/sqlite3/supervisor
RUN apt-get -y install nginx \
 && apt-get -y install redis-server redis-tools \
 && apt-get -y install sqlite3 \
 && apt-get -y install supervisor
 
# 安装mysql
RUN { \
    echo mysql-server-5.7 mysql-server/root_password password '123456'; \
    echo mysql-server-5.7 mysql-server/root_password_again password '123456'; \
} | debconf-set-selections \
 && apt-get -y install mysql-server mysql-client

# 安装调试工具软件
RUN apt-get -y install htop dstat sysstat iptraf-ng traceroute curl

# 更换pip源
RUN mkdir -p /root/.pip \
 && touch /root/.pip/pip.conf \
 && echo "[global]" >> /root/.pip/pip.conf \
 && echo "index-url = http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf \
 && echo "[install]" >> /root/.pip/pip.conf \
 && echo "trusted-host = mirrors.aliyun.com" >> /root/.pip/pip.conf
 
# 更新pip，安装numpy
RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install numpy

# 安装python依赖软件包
RUN python3 -m pip install flask==1.1.2 \
 && python3 -m pip install flask_restful==0.3.8 \
 && python3 -m pip install redis==3.2.1 \
 && python3 -m pip install psutil==5.7.0 \
 && python3 -m pip install pyzmq==20.0.0 \
 && python3 -m pip install Django==2.1.0 
 && python3 -m pip install djangorestframework==3.10.3 \
 && python3 -m pip install django-filter==2.2.0 \
 && python3 -m pip install django-cors-headers==2.5.3 \
 && python3 -m pip install django_redis==4.10.0 \
 && python3 -m pip install requests==2.23.0 \
 && python3 -m pip install configobj==5.0.6 \
 && python3 -m pip install websocket_server \
 && python3 -m pip install borax==3.2.0 \
 && python3 -m pip install tornado==5.1 \
 && python3 -m pip install PyMySQL==0.9.3 \
 && python3 -m pip install pillow \
 && python3 -m pip install xlwt \
 && python3 -m pip install xmltodict==0.12.0 \
 && python3 -m pip install apscheduler==2.1.2

# 创建文件夹
RUN mkdir -p /workspace/conf \
 && mkdir -p /workspace/log/supervisor \
 && mkdir -p /workspace/log/redis \
 && mkdir -p /workspace/log/mysql

# 设置环境变量
ENV LANG "C.UTF-8"
ENV PATH "/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/system/bin:/usr/sbin:/bm_bin:${PATH}"
ENV LD_LIBRARY_PATH "/system/lib:${LD_LIBRARY_PATH}"
ENV PYTHONPATH "/system/lib:${PYTHONPATH}"
ENV GSETTINGS_SCHEMA_DIR "/workspace/conf/gsettings"

# 清理无用软件包
RUN apt-get autoremove -y --purge gcc \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/*

RUN apt-get clean \
 && ldconfig \
 && rm -rf /var/lib/apt/lists/*
```

使用Dockerfile构建镜像的脚本（仅供参考）：build\_demo\_image\_on\_x86.sh

{% file src="../.gitbook/assets/build_demo_image_on_x86.sh" %}

```bash
#!/bin/bash

currTime=$(date +"%Y%m%d")
TARGET_ARCH="x86"
REP_NAME="demo"
VERSION="v1.0.0"
BASE_IMAGE="bmnnsdk2-bm1684-dev-ubuntu1604"

REPOSITORY="${TARGET_ARCH}/${REP_NAME}"
TAG="${VERSION}-${BASE_IMAGE}"
DockerBuildFile="Dockerfile.x86"
DockerImageFile="images/${TARGET_ARCH}_${BASE_IMAGE}_${REP_NAME}_${VERSION}_${currTime}.tar.gz"

echo "========================================================================="

echo $(date +"%Y-%m-%d %T")
echo "========================================================================="
echo " build info: "
echo "========================================================================="
echo "Dockerfile using:       ${DockerBuildFile}"
echo "Target image:           ${REPOSITORY}:${TAG}"
echo "Target file:            ${DockerImageFile}"
echo "========================================================================="
echo "start to build docker"
echo "========================================================================="
docker build -t ${REPOSITORY}:${TAG} -f ${DockerBuildFile} .
echo "========================================================================="
docker images | grep "${REPOSITORY}" | grep "${TAG}"
if [ $? -ne 0 ] ;then
    echo "build ${REPOSITORY}:${TAG} failed"
    exit -1
fi

echo "========================================================================="
echo "build ${REPOSITORY}:${TAG} success"
echo "========================================================================="
echo "start to save file ..."
docker save ${REPOSITORY}:${TAG} | gzip > ${DockerImageFile}
echo "========================================================================="
if [ $? -ne 0 ] ;then
    echo "save to file failed"
else
    echo "save to file ${DockerImageFile} success"
fi
echo "========================================================================="
```

#### 5.2.3 加载docker镜像

```bash
docker load -i xxxxxxxxx.tar.gz
```

#### 5.2.4 创建docker容器运行

运行脚本文件（仅供参考）：run\_demo\_docker\_on\_x86.sh

{% file src="../.gitbook/assets/run_demo_docker_on_x86.sh" %}

```bash
#!/bin/bash

###  x86/demo   v1.0.0-bmnnsdk2-bm1684-dev-ubuntu1604

REPO="x86"
IMAGE="demo"
TAG="v1.0.0-bmnnsdk2-bm1684-dev-ubuntu1604"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR
echo "$REPO/$IMAGE:$TAG"

if [ -c "/dev/bm-sophon0" ]; then
  for dev in $(ls /dev/bm-sophon*);
  do
    mount_options+="--device="$dev:$dev" "
  done
  CMD="docker run \
      --privileged=true \
      --network=bridge \
      --workdir=/workspace \
      ${mount_options} \
      --device=/dev/bmdev-ctl:/dev/bmdev-ctl \
      -p 80:80 \
      -v /dev/shm --tmpfs /dev/shm:exec \
      -v /dev:/dev \
      -v /etc/localtime:/etc/localtime \
      -e LOCAL_USER_ID=`id -u` \
      -itd $REPO/$IMAGE:$TAG \
      /workspace/start.sh
  "
else
  echo "No Sophon Series Deep Learning Accelerator, docker will run in dev mode"
  CMD="docker run \
      --privileged=true \
      --network=bridge \
      --workdir=/workspace \
      -p 80:80 \
      -v /dev/shm --tmpfs /dev/shm:exec \
      -v /etc/localtime:/etc/localtime \
      -e LOCAL_USER_ID=`id -u` \
      -itd $REPO/$IMAGE:$TAG \
      bash
  "
fi

echo $CMD
eval $CMD
```
