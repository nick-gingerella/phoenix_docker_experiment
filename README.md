# Initial Container Setup

This guide will help you set up two containers, `phoenix_app_base` (where your code will live and run) and `phoenix_app_db` (the database container that the Phoenix app connects to).

## Steps

1. **Ensure Host Code Directory Exists:**

   Make sure the `host_code` directory exists on your host machine, and uncomment the first volume definition in the `docker-compose.yml` file. The second volume definition should be commented out.

   ```yaml
   services:
       phoenix_app:
           volumes:
               - ./app_code:/opt/host_code # use to initially copy generated hello_world app
               #- ./app_code:/opt # after you copied the starter project to your host app_code folder
   ```

2. **Build Docker Images:**

   Navigate to the `docker_files` directory and run the `build_images.sh` script to build the PostgreSQL database and Phoenix images.

   ```bash
   cd docker_files
   ./build_images.sh
   ```

3. **Start Containers:**

   Use Docker Compose to bring up the containers.

   ```bash
   docker-compose up -d
   ```

4. **Copy Hello World Project:**

   Go into the `app_code` directory. There should be a `hello_world` directory in there that the Phoenix image file created. Copy it to your `app_code` directory.

5. **Shutdown Containers:**

   Shut down the containers using Docker Compose.

   ```bash
   docker-compose down
   ```

6. **Update Docker Compose File:**

   Edit the `docker-compose.yml` file to use the second volume mount line. This will allow your copy of the `hello_world` project to overwrite the container's `/opt` directory so you can freely change it.

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

8. **Update Configurations:**

   Change some configurations in the `app_code/hello_world` directory so Phoenix in the container can connect to the PostgreSQL database (`phoenix_app_db` container), and your host machine can connect to the Phoenix app running in the container.

   - Edit `app_code/hello_world/config/config.exists`:

     ```elixir
     # Configures the endpoint
     config :hello_world, HelloWorldWeb.Endpoint,
     url: [host: "0.0.0.0"], #<----this needs to be 0.0.0.0. not localhost
     ```

   - Edit `app_code/hello_world/config/dev.exs`:

     ```elixir
     # Configure your database
     # use these user, pass, hostname, and db (setup in the postgres dockerfile and docker-compose file at the top level)
     config :hello_world, HelloWorld.Repo,
     username: "developer",
     password: "password",
     hostname: "phoenix_app_db",
     database: "phoenix_app",
     stacktrace: true,
     show_sensitive_data_on_connection_error: true,
     pool_size: 10

     config :hello_world, HelloWorldWeb.Endpoint,
     # Binding to loopback ipv4 address prevents access from other machines.
     # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
     http: [ip: {0, 0, 0, 0}, port: 4000], #<------- change to 0.0.0.0, not 127.0.0.1
     ```

9. **Start Phoenix Server:**

   - Attach to the container using the helper script:

     ```bash
     ./attach_to_phoenix.sh
     ```

   - Change to the `hello_world` directory and start the server:

     ```bash
     cd hello_world
     mix phx.server
     ```

   If the server starts without issue, you should be able to go to `localhost:4000` in your host's browser and see the Phoenix Elixir app getting started page!

```
