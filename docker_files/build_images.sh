#!/bin/zsh
# Build all docker images in images directories
# Usage: ./build_images.sh

set -x

# set name of app to what you want. will default to "hello_world" if empty
PROJ_NAME="hello_world"
if [[ -z $1 ]]; then
  echo "using default project name for phoenix app $PROJ_NAME"
else
  PROJ_NAME=$1
fi
export DOCKER_PHOENIX_PROJECT_NAME="$PROJ_NAME"
  

# iterate through all directories under images
for dir in images/*/
do
  # remove trailing slash
  dir=${dir%*/}
  image_name=$(basename "$dir")
  pushd $dir
  # build the image using the build_image.sh script
  # verify the build script exists
  if [ ! -f ./build_image.sh ]; then
    # if the build script does not exist, skip this iteration
    echo "Error: build_image.sh not found. Skipping build for $image_name ."
    popd
    continue
  fi

  if [ "$image_name"=="phoenix" ]; then
    ./build_image.sh $DOCKER_PHOENIX_PROJECT_NAME
    unset DOCKER_PHOENIX_PROJECT_NAME
  else
    ./build_image.sh 
  fi

  popd
done
