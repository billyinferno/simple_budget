#!/bin/sh

# perform flutter clean to clean all the current build
flutter clean

# perform the flutter pub get
flutter pub get

# rebuild the flutter web apps
# flutter build web --release -t lib/main.prod.dart --verbose --no-tree-shake-icons
flutter build web --release -t lib/main.prod.dart --verbose

# build the docker based on the build
docker build -t adimartha/simple_budget .

# once finished build then get the current tag from the environment file
tag=`cat env/.prod.env | sed '2q;d' | awk -F "=" '{print $2}' | sed "s/['\"]//g" | awk -F "-" '{print $1}'`
echo current tag is $tag

# then tag the latest docker image to the current tag
echo tag latest image to $tag
docker image tag adimartha/simple_budger:latest adimartha/simple_budger:$tag

# push both of the image to the docker repo
echo push latest docker image
docker image push adimartha/simple_budger:latest

echo push $tag docker image
docker image push adimartha/simple_budger:$tag