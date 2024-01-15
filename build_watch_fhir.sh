#!/bin/bash

# options dev, stage, prod
env="prod"
location="us-central1"
repository="containers"
projectId="zanenet-njinck"
projectName="watch-fhir-$env"
appDir="."

fullVersion=$(yq eval '.version' $appDir"/pubspec.yaml")
# Take the last part of the version number, after the plus sign
version=${fullVersion#*+}

#  Because I always forget this
gcloud config set project $projectId
# only needed the first time
# gcloud auth login

cd $appDir && 

# Build the docker container
docker build -t $projectName .

registryLocation="$location-docker.pkg.dev/$projectId/$repository/$projectName"

# tag the docker container
docker tag $projectName $registryLocation

# push the tagged image into the artifact registry
docker push $registryLocation

# return back to root directory
cd ..

# deploy on google cloud
gcloud run deploy $projectName --image $registryLocation