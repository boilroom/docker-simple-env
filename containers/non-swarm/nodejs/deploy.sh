# === MAIN SETTINGS ===========================================================
service_name=nodejs-app                     # Docker service name
netwrork_name=simple-deploy-bridge          # Docker inner network (bridge) name
port=3000                                   # Application port
# =============================================================================

timeout=600                                 # Max time to build and run new container. Process canceled if timeout reached

timeout_counter=0                           # Timeout counter
error=""                                    # Error message

old_container_id=$(docker ps -f name=$service_name -q | tail -n1) # Get old container id
docker-compose up -d --no-deps --scale $service_name=2 --no-recreate $service_name # Build and run new container
new_container_id=$(docker ps -f name=$service_name -q | head -n1) # Get new container id
while :
do
  printf "."; # Show "progress"
  timeout_counter=$(( timeout_counter + 1 )) # Increment timeout counter

  is_try_to_restart=$(docker inspect -f {{.State.Restarting}} $new_container_id) # Check if container try to restart (for example, this happens when an application build error occurs)
  if [ $is_try_to_restart = "true" ]; then # If container try to restart, then set error message and break loop
    error="container try to restart"
    break
  fi
  if [ $timeout_counter -gt $timeout ]; then # If timeout reached, then set error message and break loop
    error="build and run timeout reached"
    break
  fi

  # Check if application in new container is ready (then it ready, it will be listening on $port inside container) then break loop
  docker exec -it $(docker ps --all --filter id=$new_container_id --format "{{.Names}}") sh -c "fuser $port/tcp" > /dev/null 2>&1 && break

  sleep 1
done

sleep 1 # Wait 1 second to be sure that application is ready

if [ ! -z "${error}" ]; then # If error message is not empty, then show error message and rollback
  echo "Error: $error"
  echo "Rollback"
  docker network disconnect $netwrork_name $new_container_id -f > /dev/null 2>&1 # Disconnect new container from network
  docker stop $new_container_id > /dev/null 2>&1 # Stop new container
  docker rm $new_container_id > /dev/null 2>&1  # Remove new container
  exit 1; # Exit with error
fi

# If all is ok, then disconnect old container from network, stop and remove it:

docker network disconnect $netwrork_name $old_container_id -f > /dev/null 2>&1 # Disconnect old container from network
docker stop $old_container_id > /dev/null 2>&1 # Stop old container
docker rm $old_container_id > /dev/null 2>&1 # Remove old container

docker rename $new_container_id "$service_name-1" > /dev/null 2>&1 # Rename new container to old container name (for example, serviceName-240 -> serviceName->1)

echo "Done" # Show "Done" message)