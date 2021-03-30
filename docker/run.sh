#!/bin/bash
TAG=$(docker images | grep reverse-proxy | awk 'NR==1{print$2}')
echo $TAG
export TAG=$TAG
docker-compose -f ./docker-compose.yaml up -d reverse-proxy mysql university