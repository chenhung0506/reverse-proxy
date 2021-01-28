#!/bin/bash
docker rm -f reverse-proxy
docker rmi chenhung0506/reverse-proxy:$(docker images | grep reverse-proxy | awk 'NR==1{print$2}')
set -e

REPO=chenhung0506
CONTAINER=reverse-proxy
GIT_HEAD="$(git rev-parse --short=7 HEAD)"
GIT_DATE=$(git log HEAD -n1 --pretty='format:%cd' --date=format:'%Y%m%d-%H%M')
TAG="${GIT_HEAD}-${GIT_DATE}"
IMAGE_NAME=$REPO/$CONTAINER:$TAG

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDROOT=$DIR

cd $BUILDROOT

# Build docker --no-cache
cmd="docker build -t $IMAGE_NAME -f $DIR/Dockerfile $BUILDROOT"
echo $cmd
eval $cmd

echo $IMAGE_NAME