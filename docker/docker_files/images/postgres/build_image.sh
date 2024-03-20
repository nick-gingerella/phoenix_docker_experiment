#!/bin/zsh

if [ -n "$1" ]; then
  PROJECT_NAME=$1
else
  echo "Project Name for image build not defined"
  exit 1
fi

docker build -t postgres:$PROJECT_NAME .
