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