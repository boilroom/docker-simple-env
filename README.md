# Simple Docker Environment

## What is it

A set of templates for creating a simple environment from Docker containers. It can be used both for development and for hosting applications on the server.

The author hopes that this will help you understand the basics of working with Docker faster and spend less time on it than he spent himself.

🔥 **Important!** The author is not a qualified specialist in the field of system administration and **strongly does not recommend** using **anything** from this repository to host anything more important than your pet projects on the server.

## Modules

- [Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager) (by [jc21](https://github.com/jc21) 👍❤️🔥)
- MariaDB
- PHPMyAdmin
- Redis

Nginx Proxy Manager is mainly used to redirect domain name requests to a specific container with an application. Nginx Proxy Manager also allows you to quickly get certificates for domains, configure redirects and enable things like HTTP/2, etc.

## How it works

Find the template along the path: `./env/ -> (non-swarm or swarm) -> (dev or prod)`. For example, if you need a template to be placed on the server + SWARM will be used (on one machine, to implement a deployment with zero downtime), then the template will be located at `./env/swarm/prod`. Read the readme.md file located in the directory, follow the instructions.

## Networking between containers

During development, we can keep any ports open. However, this is completely unacceptable when placing the application in the public domain. For example, your database or your application should be available only for requests from your containers, but not for direct requests from outside. Unless, of course, you have a good reason to do otherwise.

You can access (or send a request) to a container inside the Docker network by using the service name specified in the corresponding compose.yml file. For example, we have a container in which our database works:

```yml
version: '3.8'
services:
  dse-db:
    image: mariadb:latest
    networks:
      - overlay
      - bridge
  ...
```

The name of the service in this example is `dse-db` and we can access the database using `dse-db` as the host and the port that listens to our container (for Mysql and MariaDB, this is `3306` by default).

If we have an application written in Node.js and running in another container (located on the **same network** as the container with the database), then connecting to the database from inside this container will look something like this:

```javascript
  const connection = mysql.createConnection({
    host: 'dse-db',
    port: 3306,
    ...
  });
```

❗️**Note.** If you don't have a regular Docker container stack of containers (tasks, in terms of SWARM), then you may need a slightly different syntax to access them: `tasks.SERVICE_NAME_FROM_YML.` (a dot at the end is required). For example, to access the database from the example above if it is running in SWARM mode: `tasks.dse-db.`

### Networking between containers in Nginx Proxy Manager

Suppose you have a container with an application that listens on port `3001`. In your compose.in the yml file, it has the service name `mygreatapp`. And you want to make it respond when a request is made to your domain somedomain.com . To do this, you create a new proxy host in the Nginx Proxy Manager control panel (initially available at `YOUR_SERVER_IP:81` or `localhost:81`). In the "Forward Hostname / IP" field, specify `mygreatapp` (or `tasks.mygreatapp.` if it's SWARM), and as the port - 3001. Save. After that, your application should be available at http://somedomain.com. You can read about other settings on the Nginx Proxy Manager [page on github](https://github.com/NginxProxyManager/nginx-proxy-manager) or on the [project website](https://nginxproxymanager.com/). Done!
