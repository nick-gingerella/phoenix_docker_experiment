#!/bin/zsh
# Build all docker images in images directories
# Usage: ./build_images.sh

set -x

# if no project name is passed, error
if [ -z $1 ]; then
  echo "Error: no project name passed. Usage: ./build_images.sh <project-name>"
  exit 1
fi

if [ -z $2 ]; then
  echo "Error: no project port passed. Usage: ./build_images.sh <project-name> <project-port>"
  exit 1
fi

if [ -z $3 ]; then
  echo "Error: no project db name passed. Usage: ./build_images.sh <project-name> <project-port> <project-db-name>"
  exit 1
fi

if [ -z $4 ]; then
  echo "Error: no project db user passed. Usage: ./build_images.sh <project-name> <project-port> <project-db-name> <project-db-user>"
  exit 1
fi

if [ -z $5 ]; then
  echo "Error: no project db password passed. Usage: ./build_images.sh <project-name> <project-port> <project-db-name> <project-db-user> <project-db-password>"
  exit 1
fi

# set name of app to what you want
PROJ_NAME="${1}"
PROJ_PORT="${2}"
PROJ_DB_NAME="${3}"
PROJ_DB_USER="${4}"
PROJ_DB_PASS="${5}"

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

  # if project name is passed, pass it to the build script. If not, echo error
  pwd dir
  if [ -z $PROJ_NAME ]; then
    echo "Error: no project name passed. Usage: ./build_images.sh <project-name>"
  else
    echo "Building image for $image_name with project name $PROJ_NAME"
    if [[ $image_name == "phoenix" ]]; then
        ./build_image.sh $PROJ_NAME $PROJ_PORT $PROJ_DB_NAME $PROJ_DB_USER $PROJ_DB_PASS
    else
        ./build_image.sh $PROJ_NAME
    fi
  fi
  
  popd
done
