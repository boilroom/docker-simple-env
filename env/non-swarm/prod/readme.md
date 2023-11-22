# PRODUCTION variant without SWARM

**Do not use in REAL production!**

Create one network (bridge). Run in the terminal:

```
docker network create simple-deploy-bridge
```


## Create and change the values in the .env file

🔥 Create a new .env file with the following contents (in the same directory as the compose.yml file):

```yml
PHP_ADMIN_IMAGE=phpmyadmin:latest
MYSQL_ROOT_PASSWORD=change-me!
MYSQL_USER=root
MYSQL_PASSWORD=change-me!
MYSQL_DATABASE=dsemain
```

🔥 View the .env file and edit the values. Be sure to change the password to the database.


## Run containers

Just run:

```
docker compose up
```

Or if you want to run docker containers in background **(recommended)**:

```
docker compose up -d
```

## Networking between containers

Read a more detailed description on the [main page readme](../../../)

## DB connection

You can connect to MariaDB (MySQL) using **dse-db** service name as the host (Node JS MySQL connection example):

```javascript
  const connection = mysql.createConnection({
    host: 'dse-db',
    user: 'root',
    password: 'change-me!',
    database: 'dsemain'
  });
```

Default MariaDB port: **3306**

## Redis connection

You can connect to Redis using **dse-redis** service name as the host (Node JS Redis connection example):

```javascript
  const client = await createClient({
    socket: {
      host: 'dse-redis',
    }
  });
```

Default Redis port: **6379**

## Linking a domain name to your application

In order for your application to open when a domain name is requested (for example, somedomain.com ) you need to create a new proxy host in the Nginx Proxy Manager panel. More about this — in the file readme.md on the [main page](../../../) of this repository.

## PHPMyAdmin

Allocate some subdomain to access PHPMyAdmin and redirect it to the `dse-phpmyadmin` host with port `80` in Nginx Proxy Manager. Do not open the port for phpMyAdmin. Direct access via the IP of your server with an open port is unsafe!