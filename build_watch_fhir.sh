#!/bin/bash

# options dev, stage, prod
env="dev"
location="us-central1"
repository="cuestionario-sandbox"
projectId="mayjuun-questions-and-recipes"
projectName="watch-fhir-meld"
appDir="."

fullVersion=$(yq eval '.version' $appDir"/pubspec.yaml")
# Take the last part of the version number, after the plus sign
version=${fullVersion#*+}

#  Because I always forget this
gcloud config set project $projectId
# only needed the first time
# gcloud auth login

# galleriaCredentials="lib/galleria_credentials.dart"

cd $appDir && 

# sed -i -e "s/\"env\": \".*\",/\"env\": \"$env\",/g" $galleriaCredentials &&

# # Build the docker container
docker build -t $projectName .

# registryLocation="$location-docker.pkg.dev/$projectId/$repository/$projectName"

# # tag the docker container
# docker tag $projectName $registryLocation

# # push the tagged image into the artifact registry
# docker push $registryLocation

# # return back to root directory
# cd ..

# # deploy on google cloud
# gcloud run deploy $projectName --image $registryLocation