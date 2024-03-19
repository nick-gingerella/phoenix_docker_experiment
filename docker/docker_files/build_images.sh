#!/bin/zsh
# Build all docker images in images directories
# Usage: ./build_images.sh

set -x

# if no project name is passed, error
if [ -z $1 ]; then
  echo "Error: no project name passed. Usage: ./build_images.sh <project-name>"
  exit 1
fi

# set name of app to what you want
PROJ_NAME="${1}"

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

  ./build_image.sh $PROJ_NAME
  
  popd
done
