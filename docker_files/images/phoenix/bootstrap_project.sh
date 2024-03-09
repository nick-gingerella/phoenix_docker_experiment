#/bin/bash

# if hello_world directory doesn't exist, make it
if [ ! -d "hello_world" ]; then
  # cd into hello_world and run 'mix phx.new hello_world'
  echo yes | mix phx.new hello_world 
  cd hello_world
  echo yes | mix deps.get
fi
