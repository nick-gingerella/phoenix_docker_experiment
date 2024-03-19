#/bin/bash

set -x

if [[ -z "${PHOENIX_PROJECT_NAME}" ]]; then
  echo "PHOENIX_PROJECT_NAME environment var not defined"
  exit 1
else
  echo "creating project $PHOENIX_PROJECT_NAME"
fi

# if hello_world directory doesn't exist, make it
if [ ! -d "$PHOENIX_PROJECT_NAME" ]; then
  # cd into hello_world and run 'mix phx.new hello_world'
  echo yes | mix phx.new $PHOENIX_PROJECT_NAME
  cd $PHOENIX_PROJECT_NAME
  echo yes | mix deps.get
fi
