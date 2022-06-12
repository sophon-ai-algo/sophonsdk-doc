#!/bin/bash

TARGET_ARCH="arm64v8"
REP_NAME="demo"
VERSION="v1.0.0"
BASE_IMAGE="sophon_soc-1.0.1"

REPOSITORY="${TARGET_ARCH}/${REP_NAME}"
TAG="${VERSION}-${BASE_IMAGE}"
DockerBuildFile="Dockerfile.arm.sophon_soc-1.0.1"
DockerImageFile="../images/${TARGET_ARCH}_${BASE_IMAGE}_${REP_NAME}_${VERSION}.tar.gz"

echo "========================================================================="
currTime=$(date +"%Y-%m-%d %T")
echo $currTime
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
