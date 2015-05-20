#!/bin/sh

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

if [ "$1" == "all" ]
then
	RUBIES=`cat RUBIES`
else
	RUBIES="$1"
fi

for VERSION in $RUBIES
do
	OUTPUT_TAG="aggronerd/passenger-ruby:$VERSION"
	sed "s/\!\!RUBY_VERSION\!\!/$VERSION/g" Dockerfile > $DOCKERFILE_LOCATION
	docker build -f $DOCKERFILE_LOCATION -t $OUTPUT_TAG .

	if [ $? -eq 0 ] 
	then
		echo "\nSuccessfully built $OUTPUT_TAG"
	else
		echo "\nFailed to build $OUTPUT_TAG"
		exit 1
	fi	
done
	