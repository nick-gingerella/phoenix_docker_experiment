#!/bin/zsh

if [ -n "$1" ]; then
  PROJECT_NAME=$1
else
  echo "Project Name for image build not defined"
  exit 1
fi

if [ -n "$2" ]; then
  PHOENIX_PORT=$2
else
  echo "Phoenix listen port for image build not defined"
  exit 1
fi

if [ -n "$3" ]; then
  PHOENIX_DB_NAME=$3
else
  echo "Phoenix database name for image build not defined"
  exit 1
fi

if [ -n "$4" ]; then
  PHOENIX_DB_USER=$4
else
  echo "Phoenix database user for image build not defined"
  exit 1
fi

if [ -n "$5" ]; then
  PHOENIX_DB_PASSWORD=$5
else
  echo "Phoenix database password for image build not defined"
  exit 1
fi

#docker build --build-arg PROJECT_NAME=$PROJECT_NAME -t phoenix_app:base .
docker build --build-arg PROJECT_NAME=$PROJECT_NAME --build-arg PHOENIX_PORT=$PHOENIX_PORT --build-arg PHOENIX_DB_NAME=$PHOENIX_DB_NAME --build-arg PHOENIX_DB_USER=$PHOENIX_DB_USER --build-arg PHOENIX_DB_PASSWORD=$PHOENIX_DB_PASSWORD -t $PROJECT_NAME .
