# Node.js simple container

A simple container for Node.js applications. Change the service name in compose.yml to the one you need. If you use deploy.sh (read more about it below), then don't forget to edit it as well.

## How to launch

Copy the `compose.yml`, `deploy.sh` (if you want to use it) files and `app` folder to the directory you need.

The application files are assumed to be in the `app` directory.

Configure the `command` part of the compose.yml file according to your application.

Run in the terminal in compose.yml folder:

```
docker compose up
```

Or if you want to run docker containers in background **(recommended)**:

```
docker compose up -d
```

## deploy.sh file

Running this script in the terminal will result in a seamless (not guaranteed in fact) replacement of the container with the old version of the application to the container with the new version.

Before using the script, you need to replace the values of the `service_name`, `netwrork_name` and `port` variables with yours. The value of the `service_name` variable corresponds to service name from your compose.yml file. Variable `netwrork_name` corresponds to the bridge network name specified in the compose.yml file.