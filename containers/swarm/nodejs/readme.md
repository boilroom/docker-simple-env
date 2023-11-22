# Node.js simple container

A simple SWARM container for Node.js applications. Change the service name in compose.yml to the one you need. If you use deploy.sh (read more about it below), then don't forget to edit it as well.

## How to launch

Copy the `compose.yml`, `deploy.sh` (if you want to use it) files and `app` folder to the directory you need.

The application files are assumed to be in the `app` directory.

Configure the `command` and `healthcheck -> test` parts of the compose.yml file according to your application.

Run in the terminal in compose.yml folder:

```
docker stack deploy -c compose.yml SERVICE_NAME
```

Where SERVICE_NAME is the name of your service. For example, `my-great-app`.

## deploy.sh file

Running this script in the terminal will result in a seamless replacement of the container (or containers if the number of replicas is more than one) with the old version of the application to the container with the new version.

Before using the script, you need to replace the values of the `stack_name` and `replicas` variables with yours. The value of the `stack_name` variable corresponds to SERVICE_NAME, and `replicas` corresponds to the number of replicas specified in the compose.yml file.