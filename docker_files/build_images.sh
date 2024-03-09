#!/bin/zsh
# Build all docker images in images directories
# Usage: ./build_images.sh

# iterate through all directories under images
for dir in images/*/
do
  # remove trailing slash
  dir=${dir%*/}
  pushd $dir
  # build the image using the build_image.sh script
  # verify the build script exists
  if [ ! -f ./build_image.sh ]; then
    # if the build script does not exist, skip this iteration
    echo "Error: build_image.sh not found. Skipping $name."
    popd
    continue
  fi

  ./build_image.sh $name

  popd
done
