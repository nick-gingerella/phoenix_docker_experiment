# Initial Container Setup

This guide will help you set up two containers, `phoenix_app_base` (where your code will live and run) and `phoenix_app_db` (the database container that the Phoenix app connects to).

## Steps

1. **Run make_project.sh to generate Phoenix + Postgres images:**

   Run `./make_project.sh -i` to start project generation. You will be prompted for info about the app you want to work on (name, port to listen on, database name, credentials, etc.)

   This will create a Phoenix App image where your code and app will live, and a Postgres image that your app will connect to. The database credentials you choose will be how the app connects to the postgres DB (which will automatically be configured to use your credentials)

   When the script finishes, you should have a `docker-compose.yml`, `attach_to_phoenix.sh`, and a `pgcli_to_db.sh` script in the top level directory, confgured to start and connect to your new phoenix app and db docker images.

2. **Start Containers:**

   Use Docker Compose to bring up the containers.

   ```bash
   docker-compose up -d
   ```

3. **Test The containers:**

   You can check the containers are working properly by starting the phoenix app server and visiting it from your dev machine's browser on `localhost:<phoenix port you chose>`

   ```
   ./attach_to_phoenix.sh

   # you should now be in the docker container running the phoenix app
   ./start_server.sh

   # the phoenix app server should now be running and listening on it's port.
   ```

   use a web browser and go to `localhost:<your phoenix port>` and verify you get teh phoenix framework startup page.

   If this worked, then the generated project in the container is configured properly, and you can move on to copying this project to your local machine so you can edit files and watch them update live with edits.

4. **Copy your Project to host machine for active development:**

   Go into the `app_code` directory. There should be a `<your project name>` directory in there that the Phoenix image file created. Copy it, and `start_server.sh` to the `host_code` directory. This maps to your `app_code` directory on your local machine, so once complete, you should be able to see the `<your project name>` directory on your dev machine.

5. **Shutdown Containers:**

   Shut down the containers using Docker Compose.

   ```bash
   docker-compose down
   ```

6. **Update Docker Compose File So the Generated app is always on your local machine:**

   Edit the `docker-compose.yml` file to use the second volume mount line. This will allow your copy of the `<your project name>` project to overwrite the container's `/opt` directory so you can freely change it.

   ```yaml
   services:
       phoenix_app:
           volumes:
               #- ./app_code:/opt/host_code # use to initially copy generated hello_world app
               - ./app_code:/opt # after you copied the starter project to your host app_code folder
   ```

7. **Start Containers Again:**

   Start up the containers using Docker Compose.

   ```bash
   docker-compose up -d
   ```

8.  **Start Phoenix Server:**

   - Attach to the container and start server using the helper script:

     ```bash
     ./attach_to_phoenix.sh
     
     # in the phoenix container
     ./start_server.sh
     ```
