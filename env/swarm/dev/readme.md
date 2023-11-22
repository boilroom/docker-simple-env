# DEV variant with SWARM

**Do not use in production!**

Run in the terminal to initialize SWARM mode
```
docker swarm init
```

Create two networks (bridge and overlay):

```
docker network create simple-deploy-bridge
```
```
docker network create -d overlay --attachable simple-deploy-overlay
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

🍏 If you are a **Mac** user on an **Apple Silicon chip**, it is recommended to change the value of PHP_ADMIN_IMAGE to `arm64v8/phpmyadmin:latest` (for better performance)

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

You can connect to MariaDB (MySQL) using **localhost** or **dse-db** service name as the host (Node JS MySQL connection example):

```javascript
  const connection = mysql.createConnection({
    host: 'dse-db', // (or localhost)
    user: 'root',
    password: 'change-me!',
    database: 'dsemain'
  });
```

Default MariaDB port: **3306**

## Redis connection

You can connect to Redis using **localhost** or **dse-redis** service name as the host (Node JS Redis connection example):

```javascript
  const client = await createClient({
    socket: {
      host: 'dse-redis', // (or localhost)
    }
  });
```

Default Redis port: **6379**

## PHPMyAdmin

You can open PHPMyAdmin in your browser at [http://localhost:8180](http://localhost:8180) or [http://127.0.0.1:8180](http://127.0.0.1:8180)