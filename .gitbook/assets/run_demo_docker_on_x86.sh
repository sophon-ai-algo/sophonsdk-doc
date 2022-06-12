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