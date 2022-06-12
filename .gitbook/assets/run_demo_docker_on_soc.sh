#!/bin/bash

###  arm64v8/demo   v1.0.0-sophon_soc-1.0.1

REPO="arm64v8"
IMAGE="demo"
TAG="v1.0.0-sophon_soc-1.0.1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR
echo "$REPO/$IMAGE:$TAG"

CMD="docker run \
    --privileged=true \
    --network=bridge \
    --workdir=/workspace \
    -p 80:80 \
    -v /system:/system \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -e LOCAL_USER_ID=`id -u` \
    -itd $REPO/$IMAGE:$TAG \
    /bin/bash /workspace/start.sh
"

echo $CMD
eval $CMD