#!/bin/bash

if [ $# -eq 0 ]
then
    echo "\nNo arguments supplied. Usage:\n\n\tsh build.sh <ruby version>\n\nFor example:\n\n\tsh build.sh 2.2.2\n"
	exit 1
fi

DOCKERFILE_LOCATION="versions/Dockerfile.$1"

if [ ! -d "versions" ]
then
	mkdir "versions"
fi

OUTPUT_TAG="aggronerd/passenger-ruby:$1"
sed "s/\!\!RUBY_VERSION\!\!/$1/g" Dockerfile > $DOCKERFILE_LOCATION
docker build -f $DOCKERFILE_LOCATION -t $OUTPUT_TAG .

if [ $? -eq 0 ] 
then
	echo "\nSuccessfully built $OUTPUT_TAG"
fi	