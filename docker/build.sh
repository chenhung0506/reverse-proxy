#!/bin/bash
docker rm -f reverse-proxy
docker rmi harbor.chlin.tk/nginx/reverse-proxy:$(docker images | grep reverse-proxy | awk 'NR==1{print$2}')
set -e

REPO=harbor.chlin.tk/nginx
CONTAINER=reverse-proxy
GIT_HEAD="$(git rev-parse --short=7 HEAD)"
GIT_DATE=$(git log HEAD -n1 --pretty='format:%cd' --date=format:'%Y%m%d-%H%M')
PUSH_IMG=false
while getopts 't:p' OPT; do
    # echo "$OPT = $OPTARG"
    case $OPT in
        t) 
           echo $GIT_DATE
           GIT_DATE=$(date +"%Y%m%d-%H%M")
           echo $GIT_DATE
           ;;
        p) PUSH_IMG=true;;
    esac
done

TAG="${GIT_HEAD}-${GIT_DATE}"
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
echo $DOCKER_IMAGE

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDROOT=$DIR

cd $BUILDROOT

# Build docker --no-cache
cmd="docker build -t $DOCKER_IMAGE -f $DIR/Dockerfile $BUILDROOT"
echo $cmd
eval $cmd

echo 'PUSH_IMG:' $PUSH_IMG
if [ $PUSH_IMG = 'true' ] ; then
    cmd="docker push $DOCKER_IMAGE"
    echo $cmd && eval $cmd
fi