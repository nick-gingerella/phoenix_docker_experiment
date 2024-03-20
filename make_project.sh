#!/bin/zsh

# default values for names needed in build + configuration process
default_project_name="hello_world"
default_phoenix_port=4000
default_db_name="hello_world"
default_db_user="postgres"
default_db_pass="postgres"
default_db_port=5432

usage() {
    echo "Usage: $0 -i | [-n <project-name>] [-p <phoenix_port>] [-d <db_name>]" 1>&2
    exit 1
}

# if no arguments are passed, show usage
if [ $# -eq 0 ]
then
    usage
fi

# Main entry point
main() {
  OPTSTRING=":hin:p:d:"
  while getopts ${OPTSTRING} opt; do
      case ${opt} in
          h ) 
            usage
            ;;
          i )
             interactive_mode=1
             ;;
          n)
             project_name=${OPTARG}
             if ! [[ $project_name =~ ^[a-zA-Z0-9_]+$ ]]
             then
                 echo "Option -${OPTARG} requires an argument" 1>&2
                 usage
             fi
             ;;
          p )
             phoenix_port=${OPTARG}
             if ! [[ $phoenix_port =~ ^[0-9]+$ ]]
             then
                 echo "Option -${OPTARG} requires an argument" 1>&2
                 usage
             fi
             ;;
          d )
             db_name=${OPTARG}
             if ! [[ $db_name =~ ^[a-zA-Z0-9_]+$ ]]
             then
                 echo "Option -${OPTARG} requires an argument" 1>&2
                 usage
             fi
             ;;
          : )
             echo "Option -${OPTARG} requires an argument." 1>&2
             usage
             ;;
          ? )
             echo "Invalid option: -${OPTARG}" 1>&2
             usage
             ;;
      esac
  done
  shift $((OPTIND -1))

  if [ -n "$interactive_mode" ]
  then
      interactive
  fi


# if project_name is not defined, use default
    if [ -z "$project_name" ]
    then
        project_name=${default_project_name}
    fi  

  # if phoenix_port is not defined, use default
  if [ -z "$phoenix_port" ]
  then
      phoenix_port=${default_phoenix_port}
  fi

    # if db_name is not defined and a project_name is not defined, use default
  if [ -z "$db_name" ]
  then
      if [ -z "$project_name" ]
      then
          db_name=${default_db_name}
      else
          db_name=${project_name}
      fi
  fi

  # if db_user is not defined, use default
  if [ -z "$db_user" ]
  then
      db_user=${default_db_user}
  fi

    # if db_pass is not defined, use default
  if [ -z "$db_pass" ]
  then
      db_pass=${default_db_pass}
  fi

# if db_port is not defined, use default
  if [ -z "$db_port" ]
  then
      db_port=${default_db_port}
  fi

  echo "project_name: ${project_name}"
  echo "phoenix_port: ${phoenix_port}"
  echo "db_name: ${db_name}"
  echo "db_user: ${db_user}"
  echo "db_pass: ${db_pass}"
  echo "db_port: ${db_port}"

  export DOCKER_BOOTSTRAP_PHOENIX_PROJECT_NAME=${project_name}
  export DOCKER_BOOTSTRAP_PHOENIX_PORT=${port_number}
  export DOCKER_BOOTSTRAP_DB_NAME=${db_name}
  export DOCKER_BOOTSTRAP_DB_USER=${db_user}
  export DOCKER_BOOTSTRAP_DB_PASS=${db_pass}
  export DOCKER_BOOTSTRAP_DB_PORT=${db_port}
  start_building_docker_stuff
  unset DOCKER_BOOTSTRAP_PHOENIX_PROJECT_NAME
  unset DOCKER_BOOTSTRAP_PHOENIX_PORT
  unset DOCKER_BOOTSTRAP_DB_NAME
  unset DOCKER_BOOTSTRAP_DB_USER
  unset DOCKER_BOOTSTRAP_DB_PASS
  unset DOCKER_BOOTSTRAP_DB_PORT

  echo "phoenix app images created"

  mv docker/docker-compose.yml .
  mv docker/attach_to_phoenix.sh .
  mv docker/pgcli_to_db.sh .
}

#interactive mode
interactive() {
  # prompt user for a project name (no spaces or special characters)
  echo "Enter a phoenix project name (no spaces or special characters). Default is ${default_project_name}:"
  read -r project_name

  # make sure project name was not empty. If so, ask for name again
  # the project name can't have spaces or special characters
  while [[ ! $project_name =~ ^[a-zA-Z_-]+$ ]]
  do
      if [ -z "$project_name" ]
      then
          project_name=${default_project_name}
          break
      fi
      echo "Project name must contain only letters. Please enter a phoenix project name (no spaces or special characters). Default is ${default_project_name}:"
      read -r project_name
  done
  echo "project_name: ${project_name}"

  # prompt user for port number phoenix wpplication will run on. Default is 4000
  echo "Enter a port number for the phoenix application to run on. Default is 4000:"
  read -r port_number
  # check if port number is empty. If so, set it to 4000
  if [ -z "$port_number" ]
  then
      port_number=4000
  fi

  # check if port number is a number. If not, ask for port number again
  while ! [[ $port_number =~ ^[0-9]+$ ]]
  do
      echo "Port number must be a number. Please enter a port number for the phoenix application to run on. Default is 4000:"
      read -r port_number
      if [ -z "$port_number" ]
      then
          port_number=4000
      fi
  done
  echo "phoenix_port: ${port_number}"

  # prompt user for a database name (no spaces or special characters). Default is project name.
  echo "Enter a database name (no spaces or special characters). Default is ${project_name}:"
  read -r db_name
  while [[ ! $db_name =~ ^[a-zA-Z0-9_]+$ ]]
    do
      if [ -z "$db_name" ]
      then
          # default
          db_name=$project_name
          break
      fi
      echo "Database name must contain only letters. Please enter a database name (no spaces or special characters). Default is ${project_name}:"
      read -r db_name
  done
  echo "db_name: ${db_name}"

  # prompt user for a database user. Default is postgres
  echo "Enter a database user. Default is postgres:"
  read -r db_user  

  # db must contain only letters and no special characters
  while [[ ! $db_user =~ ^[a-zA-Z0-9_]+$ ]]
  do
      if [ -z "$db_user" ]
      then
          # default
          db_user="postgres"
          break
      fi
      echo "Database user must contain only letters. Please enter a database user. Default is postgres:"
      read -r db_user
  done
  echo "db_user: ${db_user}"

  # prompt user for a database password. Default is postgres
  echo "Enter a database password. Default is postgres:"
  read -r db_pass

  if [ -z "$db_pass" ]
  then
      # default
      db_pass="postgres"
  fi
  echo "db_pass: ${db_pass}"

  # prompt user for a database port. Default is 5432
  echo "Enter a database port. Default is 5432:"
  read -r db_port

  # port must be a number
  while ! [[ $db_port =~ ^[0-9]+$ ]]
  do
      if [ -z "$db_port" ]
      then
          # default
          db_port=${default_db_port}
          break
      fi
      echo "Database port must be a number. Please enter a database port. Default is 5432:"
      read -r db_port
  done
  echo "db_port: ${db_port}"


  # set env variables for shell to help populate config files and scripts
  export DOCKER_BOOTSTRAP_PHOENIX_PROJECT_NAME=${project_name}
  export DOCKER_BOOTSTRAP_PHOENIX_PORT=${port_number}
  export DOCKER_BOOTSTRAP_DB_NAME=${db_name}
  export DOCKER_BOOTSTRAP_DB_USER=${db_user}
  export DOCKER_BOOTSTRAP_DB_PASS=${db_pass}
  export DOCKER_BOOTSTRAP_DB_PORT=${db_port}
  start_building_docker_stuff
  unset DOCKER_BOOTSTRAP_PHOENIX_PROJECT_NAME
  unset DOCKER_BOOTSTRAP_PHOENIX_PORT
  unset DOCKER_BOOTSTRAP_DB_NAME
  unset DOCKER_BOOTSTRAP_DB_USER
  unset DOCKER_BOOTSTRAP_DB_PASS
  unset DOCKER_BOOTSTRAP_DB_PORT

  echo "phoenix app images created"
}

# THIS IS WHERE THE MEAT OF THE WORK GOES
start_building_docker_stuff() {
  project_name=${DOCKER_BOOTSTRAP_PHOENIX_PROJECT_NAME}
  phoenix_port=${DOCKER_BOOTSTRAP_PHOENIX_PORT}
  db_name=${DOCKER_BOOTSTRAP_DB_NAME}
  db_user=${DOCKER_BOOTSTRAP_DB_USER}
  db_pass=${DOCKER_BOOTSTRAP_DB_PASS}
  db_port=${DOCKER_BOOTSTRAP_DB_PORT}

  echo "Will start building docker for phoenix project with the following configurations:"
  echo "Project Name: ${project_name}"
  echo "App listening on port ${phoenix_port}"
  echo "Connected to a Postgres database named ${db_name}"
  echo "whose database credentials are: user:${db_user} and password:${db_pass} listening on port ${db_port}"

  # if docker/docker-compose.yml exists, remove it
  if [ -f "docker/docker-compose.yml" ]
  then
      rm docker/docker-compose.yml
  fi

  # make a new docker-compose.yml file from the template
  pwd
  cp docker/docker-compose.yml.template docker/docker-compose.yml
  sed -i '' "s+<PHOENIX_APP_IMAGE_NAME>+${project_name}+g" docker/docker-compose.yml
  sed -i '' "s+<PHOENIX_APP_CONTAINER_NAME>+${project_name}+g" docker/docker-compose.yml
  sed -i '' "s+<PHOENIX_APP_HOSTNAME>+${project_name}+g" docker/docker-compose.yml
  sed -i '' "s+<PHOENIX_APP_NAME>+${project_name}+g" docker/docker-compose.yml
  sed -i '' "s+<PHOENIX_APP_LISTEN_PORT>+${phoenix_port}+g" docker/docker-compose.yml
  sed -i '' "s+<DB_NAME>+${db_name}+g" docker/docker-compose.yml
  sed -i '' "s+<DB_USER>+${db_user}+g" docker/docker-compose.yml
  sed -i '' "s+<DB_PASSWORD>+${db_pass}+g" docker/docker-compose.yml
  sed -i '' "s+<DB_PORT>+${db_port}+g" docker/docker-compose.yml

  cp docker/attach_to_phoenix.sh.template docker/attach_to_phoenix.sh
  sed -i '' "s+<PHOENIX_PROJECT_NAME>+${project_name}+g" docker/attach_to_phoenix.sh

  cp docker/pgcli_to_db.sh.template docker/pgcli_to_db.sh
  sed -i '' "s+<DB_PORT>+${db_port}+g" docker/pgcli_to_db.sh
  sed -i '' "s+<DB_USER>+${db_user}+g" docker/pgcli_to_db.sh
  sed -i '' "s+<DB_NAME>+${db_name}+g" docker/pgcli_to_db.sh

  cp docker/docker_files/images/phoenix/bootstrap_project.sh.template docker/docker_files/images/phoenix/bootstrap_project.sh
  sed -i '' "s+<PHOENIX_PROJECT_NAME>+${project_name}+g" docker/docker_files/images/bootstrap_project.sh

  cp docker/docker_files/images/phoenix/start_server.sh.template docker/docker_files/images/phoenix/start_server.sh
  sed -i '' "s+<PHOENIX_PROJECT_NAME>+${project_name}+g" docker/docker_files/images/phoenix/start_server.sh
 

  # start calling build scripts
  pushd docker/docker_files
  #./docker/docker_files/build_images.sh ${project_name}
  ./build_images.sh ${project_name}
  popd

  # clean up the generated shell scripts in images directory
  rm docker/docker_files/images/phoenix/bootstrap_project.sh
  rm docker/docker_files/images/phoenix/start_server.sh
}

# a main function is used so functions can be defined throughout file
# and used in any order, since by the time this runs, all functions are defined
main "$@"; exit
