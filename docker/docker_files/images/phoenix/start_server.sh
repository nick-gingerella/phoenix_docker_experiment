#/bin/bash

# if hello_world directory exists, assume it was made using 'mix phx.new hello_world'
if [ -d "hello_world" ]; then
  # start phoenix server using mix phx.server
  cd hello_world
  mix phx.server
fi
