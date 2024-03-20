#!/bin/zsh

if [ -n "$1" ]; then
  PROJECT_NAME=$1
else
  echo "Project Name for image build not defined"
  exit 1
fi

#docker build --build-arg PROJECT_NAME=$PROJECT_NAME -t phoenix_app:base .
docker build --build-arg PROJECT_NAME=$PROJECT_NAME -t $PROJECT_NAME .
